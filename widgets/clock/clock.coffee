

untilDay = (day) ->
  now = new Date
  now.setDate(now.getDate() + (day - 1 - now.getDay() + 7) % 7 + 1)
class Dashing.Clock extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

    now = new Date()

    volgendeBorrel = null
    today = now.getDay() # 



    volgendeBorrel =
      if today is 2 or today is 4
        now.setHours(17)
        now.setMinutes(0)
        now.setSeconds(0)
        now.setMilliseconds(0)
        now
      else
        nextTuesday = untilDay(2)
        nextThursday = untilDay(5)      
        if nextTuesday > nextThursday
          new Date(nextTuesday)
        else
          new Date(nextThursday)


    console.log(volgendeBorrel)


    countdown volgendeBorrel, (ts) ->
      document.getElementById('cd').innerHTML = "<strong>Volgende borrel:</strong> " + ts.toString();
  startTime: =>
    today = new Date()

    h = today.getHours()
    m = today.getMinutes()
    s = today.getSeconds()
    m = @formatTime(m)
    s = @formatTime(s)
    @set('time', h + ":" + m + ":" + s)
    @set('date', today.toDateString())

  formatTime: (i) ->
    if i < 10 then "0" + i else i