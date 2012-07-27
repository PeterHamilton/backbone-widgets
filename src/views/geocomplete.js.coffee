#= require jquery.geocomplete

class Backbone.Widgets.Geocomplete extends Backbone.Form.editors.Base
  tagName: 'div'
  defaultValue: ''
  attributes:
    style: 'width: 600px'

  formatted_address: null
  geocodes: {}

  initialize: (options) =>
    super(options)

    @setValue(@value)

  # backbone form interface
  getValue: =>
    @geocodes

  setValue: (value) =>
    @formatted_address = value

  # view methods
  render: =>
    @$el.html HandlebarsTemplates['geocomplete']()

    @$el.find('input.geocomplete').geocomplete
      map: @$el.find('.map-canvas')
      location: @formatted_address
    @$el.on 'geocode:result', (event, result) =>
      postal_code_component = _(result.address_components).find (component) ->
        component.types[0] == 'postal_code'

      @geocodes =
        zip_code: if postal_code_component?.short_name?
                    postal_code_component.short_name
                  else
                    null
        latitude: result.geometry.location.$a
        longitude: result.geometry.location.ab
        address: result.formatted_address

    @
