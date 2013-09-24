#= require jquery.readingtime

$(document).ready ->
  # For each blog post
  $("article").each ->
    # Calculate Reading Time
    ert = $(this).readingtime()
    # Append it to post header if not zero
    $(this).find("> header").append "<div class='reading-time'><span class='ss-icon'>time</span>" + ert + " min de leitura</div>"  if ert > 0
