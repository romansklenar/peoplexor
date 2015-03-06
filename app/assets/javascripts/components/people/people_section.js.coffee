# @cjsx React.DOM

@PeopleSection = React.createClass
  # Display name used for debugging
  displayName: 'PeopleSection'

  # Invoked before the component is mounted and provides the initial
  # state for the render method.
  getInitialState: ->
    # We'll change it to true once we fetch data
    didFetchData: false
    # The people JSON array used to display the cards in the view
    people: []

  # Invoked right after the component renders
  componentDidMount: ->
    # Lets fetch all the people...
    @_fetchPeople({})

  # AJAX call to our PeopleController
  _fetchPeople: (data)->
    $.ajax
      url: Routes.people_path()
      dataType: 'json'
      data: data
    .done @_fetchDataDone
    .fail @_fetchDataFail

  # If the AJAX call is successful...
  _fetchDataDone: (data, textStatus, jqXHR) ->
    # We change the state of the component. This will cause the component and
    # it's children to render again
    @setState
      didFetchData: true
      people: data

  # If errors in AJAX call...
  _fetchDataFail: (xhr, status, err) =>
    console.error @props.url, status, err.toString()

  # Handler for the submit event on the PeopleSearch component
  _handleOnSearchSubmit: (search) ->
    # Lets fetch some people by the user's input
    @_fetchPeople
      search: search

  # How the component is going to be rendered to the user depending on it's
  # props and state...
  render: ->
    # The collection of PersonCard components we are going to display
    # using the people stored in the component's state
    cardsNode = @state.people.map (person) ->
      # PersonCard component with a data property containing all the JSON
      # attributes we are going to use to display it to the user
      <PersonCard key={person.id} data={person}/>

    # HTML displayed if no people found in it's state
    noDataNode =
      <div className="warning">
        <span className="fa-stack">
          <i className="fa fa-meh-o fa-stack-2x"></i>
        </span>
        <h4>No people found...</h4>
      </div>

    # Here starts the render result
    <div>
      # This is the PeopleSearch component. When it triggers it's
      # onFormSubmit, the PeopleSection will handle it as seen
      # on it's _handleOnSearchSubmit method
      <PeopleSearch onFormSubmit={@_handleOnSearchSubmit}/>
      <div className="cards-wrapper">
        {
          # If there are people render the cards...
          if @state.people.length > 0
            {cardsNode}
          # If has fetched data and no people found, render the
          # warning message instead
          else if @state.didFetchData
            {noDataNode}
        }
      </div>
    </div>
