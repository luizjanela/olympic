###### OLYMPIC GAMES API ######
by Luiz Janela

==== Purpose ====

This API is used to access and append game results of the Olympic Games.


==== Web Services ====

1. Competition Create
	Creates a Competition.

	URL: http://localhost/competition/add/ [POST]
	Input JSON:
	{
		"name": "100m", // Competition name
		"unit" : "s", // Unit name of the competition (seconds, minutes, goals ...)
		"rounds" : 3 // Integer that specifies the quantity of rounds. Always will look for the greater result "values"
	}
	Output JSON:
	{
		"result": true,
		"message" : "Competition created.",
		"data" : {
			"id" : "1233"
			"name": "100m",
			"rounds" : 3,
			"unit" : "s"
		}
	}
	Error GENERAL_ERROR Output JSON:
	{
		"result": false,
		"message" : "{Exception message}.",
		"data" : ""
	}

2. Competition Result Add
	Appends new Result of an Athlete in a Competition.

	URL: http://localhost/competition/result/add/ [POST]
	Input JSON:
	{
		"competition": "1233", // Competition Id returned in create
		"athlete" : "1234", // Athlete Id returned in create
		"value" : 10.03 // Float value of the result athlete made
	}
	Output JSON:
	{
		"result": true,
		"message" : "Result added.",
		"data" : null
	}
	Error COMPETITION_ENDED Output JSON:
	{
		"result": false,
		"message" : "Competition already ended.",
		"data" : null
	}
	Error ROUNDS_EXCEDDED Output JSON:
	{
		"result": false,
		"message" : "All rounds of this athlet already have been played.",
		"data" : null
	}
	Error GENERAL_ERROR Output JSON:
	{
		"result": false,
		"message" : "{Exception message}.",
		"data" : null
	}

3. End Competition
	Ends a Competition. No new Result can be added. 
	URL: http://localhost/competition/finish/ [POST]
	Input JSON:
	{
		"competition": "1233" // Competition Id returned in create
	}
	Output JSON:
	{
		"result": true,
		"message" : "Competition ended.",
		"data" : null
	}
	Error GENERAL_ERROR Output JSON:
	{
		"result": false,
		"message" : "{Exception message}.",
		"data" : null
	}

4. Competition Ranking
	Reads the Ranking of the Athletes in a Competition.
	URL: http://localhost/competition/{id}/ranking/ [GET]
	Output JSON:
	{
		"result": true,
		"message" : null,
		"data" : {
			{ "1234" : 9.87 }, // {Athlet id} : {athlet best result}
			{ "1233" : 5.8 },
			{ "1239" : 4.3 }
		}
	}
	Error GENERAL_ERROR Output JSON:
	{
		"result": false,
		"message" : "{Exception message}.",
		"data" : null
	}


==== Worklog ====

1. Ruby + GIT + Mongo + Sinatra configuration. Basic and mocked services created. 5h @ 2016/10/01
2. Fixes in services responses. Multiples rounds feature. Best results ranking. Documentation improvements. 2:30h @ 2016/10/03


==== Backlog / Improvements ====

- Specify exceptions for each situations.
- Create a data access layer to use a cache application for example.
- Check if the competition is already finished on the competition/finish method.
	Error COMPETITION_ALREADY_ENDED Output JSON:
	{
		"result": false,
		"message" : "Competition already ended",
		"data" : null
	}

- Define response Content-Type header as application/json.
- Specify a rounding type (use greater, use lower etc).
- Validate qty of rounds (greater than zero and integer) in competition/add.

- Insert list of athlets in competition/add.
- Define ranking criteria when values are equal. Now is defined that the older row wins.
- Change ranking to use MongoDB aggregate function.
- Validate all services inputs (type, nulls, excedding attrs)
- Append competition info in ranking 
	"competition" : {
		"id" : "1233",
		"name" : "100m",
		"unit" : "s"
	},