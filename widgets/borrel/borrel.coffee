class Dashing.Borrel extends Dashing.Widget
	ready: =>
		@set('time', "Geen volgende borrel. Ga bestuur poken ofzo.")
	onData: (borrel) =>
		console.log(borrel)
		date = new Date(borrel.when_start)
		if date > new Date()
			@countdown = countdown date, (t) =>
				@set('time', t)
				if date < new Date
					@set('time', "Geen volgende borrel. Ga bestuur poken ofzo.")
					clearInterval(@countdown)