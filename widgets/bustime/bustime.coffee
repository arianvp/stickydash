class Dashing.Bustime extends Dashing.Widget

  ready: ->
  onData: (data) =>
    items = data.items.filter (x) ->
        console.log(x)
        delay =  +x.realtimeText?.match("\\d") | 0
        s = x.time.split ':'
        hour = +s[0]
        min = +s[1] + delay


        aankomstWandel = moment().add("minutes", 0).toDate()

        vertrekBus = moment().hours(hour).minutes(min).toDate()

        console.log "#{aankomstWandel} < #{vertrekBus}"
        console.log aankomstWandel < vertrekBus

        aankomstWandel < vertrekBus

    @set("items", items)




