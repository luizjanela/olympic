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
		"athlets" : [ // Array of athlets
			{"name" : "Luiz Janela"}, // Athlet name  
			{"name" : "Usain Bolt"} 
		]
	}
	Output JSON:
	{
		"result": true,
		"message" : "Competition created",
		"data" : {
			"id" : "1233"
			"name": "100m",
			"athlets" : [
				{"id" : "1234", "name" : "Luiz Janela"}, 
				{"id" : "1235", "name" : "Usain Bolt"} 
			],
			"unit" : "s"
		}
	}
	Error GENERAL_ERROR Output JSON:
	{
		"result": false,
		"message" : "General Error. {Exception message}",
		"data" : ""
	}

2. Competition Result Add
	Appends new Result of an Athlete in a Competition.

	URL: http://localhost/competition/result/add/ [POST]
	Input JSON:
	{
		"competition": "1233", // Competition Id returned in create
		"athlete" : "1234", // Athlete Id returned in create
		"value" : 10.03 // Value of the result athlete made
	}
	Output JSON:
	{
		"result": true,
		"message" : "Result added",
		"data" : ""
	}
	Error COMPETITION_ENDED Output JSON:
	{
		"result": false,
		"message" : "Competition Ended",
		"data" : ""
	}
	Error GENERAL_ERROR Output JSON:
	{
		"result": false,
		"message" : "General Error. {Exception message}",
		"data" : ""
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
		"message" : "Competition ended",
		"data" : ""
	}
	Error COMPETITION_ALREADY_ENDED Output JSON:
	{
		"result": false,
		"message" : "Competition Already Ended",
		"data" : ""
	}
	Error GENERAL_ERROR Output JSON:
	{
		"result": false,
		"message" : "General Error. {Exception message}",
		"data" : ""
	}

4. Competition Ranking
	Reads the Ranking of the Athletes in a Competition.
	URL: http://localhost/competition/{id}/ranking/ [GET]
	Output JSON:
	{
		"result": true,
		"message" : "",
		"data" : {
			"competition" : {
				"id" : "1233",
				"name" : "100m",
				"unit" : "s"
			},
			"ranking" : [
				{ 
					"athlete" : {
						"id" : "1234",
						"name" : "Luiz Janela"
					},
					"value" : 9.87 
				},
				{ 
					"athlete" : {
						"id" : "1235",
						"name" : "Usain Bolt"
					},
					"value" : 9.89 
				}
			]
		}
	}
	Error GENERAL_ERROR Output JSON:
	{
		"result": false,
		"message" : "General Error. {Exception message}",
		"data" : ""
	}

