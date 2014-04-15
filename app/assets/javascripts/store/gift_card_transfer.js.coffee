validate_match = (self, other) ->
  if self.value != other.value
    self.setCustomValidity("e-mail addresses don't match.")
  else
    self.setCustomValidity("")

$ ->
  $('[data-validate-confirmation]').each ->
    original_value = this
    $conf_value = $("##{@.id}_confirmation")

    $(@).change ->
      validate_match(original_value, $conf_value[0])

    $conf_value.change ->
      validate_match(original_value, $conf_value[0])
