validate_match = (self, other) ->
  if self.value != other.value
    self.setCustomValidity("e-mail addresses don't match.")
  else
    self.setCustomValidity("")

# Substitute {{thing}} with the value of thing in values if it exists.
interpolateString = (string, values) ->
  string.replace /{{\s*(\w*)\s*}}/g, (placeholder, key) ->
    values[key] or ''

$ ->
  $('[data-validate-confirmation]').each ->
    original_value = this
    $conf_value = $("##{@.id}_confirmation")

    $(@).change ->
      validate_match(original_value, $conf_value[0])

    $conf_value.change ->
      validate_match(original_value, $conf_value[0])

  $('#send-to-a-friend-submit').click (e) ->
    e.preventDefault()

    sending_to = $("#gift_card_email").val()
    amount = $("#gift_card_transfer_amount").val()
    values = { sending_to: sending_to, amount: amount }
    message = interpolateString(Spree.translations.gc_confirmation, values)

    if confirm(message)
      $(@).closest('form').submit()


