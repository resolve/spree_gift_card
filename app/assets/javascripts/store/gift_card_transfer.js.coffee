# Substitute {{thing}} with the value of thing in values if it exists.
interpolateString = (string, values) ->
  string.replace /{{\s*(\w*)\s*}}/g, (placeholder, key) ->
    values[key] or ''

$ ->
  $('#send-to-a-friend-submit').click (e) ->
    sending_to = $("#gift_card_email").val()
    amount = $("#gift_card_transfer_amount").val()
    return if sending_to == "" || amount == ""

    e.preventDefault()
    values = { sending_to: sending_to, amount: amount }
    message = interpolateString(Spree.translations.gc_confirmation, values)
    if confirm(message)
      $(@).closest('form').submit()

