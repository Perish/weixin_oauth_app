#= require jquery
#= require tether
#= require bootstrap-sprockets
#= require jquery_ujs
#= require turbolinks


$(document).on 'turbolinks:load', -> 
  $(".select_all").on 'change', -> 
    qrcodes = $(".qrcode")
    if this.checked
      qrcodes.prop('checked',true)
    else
      console.log("dddd")
      qrcodes.prop('checked',false)