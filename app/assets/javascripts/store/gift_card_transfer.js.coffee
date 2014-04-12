validate_match = (self, other) ->
  if self.value != other.value
    self.setCustomValidity("e-mail addresses don't match.")
  else
    self.setCustomValidity("")

$ ->
  $('[data-validate-confirmation]').each ->
    original_value = this

    $(@).change (event) ->
      validate_match(original_value, event.target)

    $("##{@.id}_confirmation").change (event) ->
      validate_match(event.target, original_value)
