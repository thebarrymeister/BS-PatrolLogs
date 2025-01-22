# BS-PatrolLogs
FiveM script that sends webhooks to Discord about patrol times of police.

Howdy! This script is very plain. It sends webhook messages to Discord in regards to when an Officer starts patrol and ends patrol. It will also give a total time of the patrol. This is setup for a city I dev in.

It utilizes ox_lib:notify as we do not use a chat box. 
Commands are as follows:
/patrolPD #Starts patrol as PD
/patrolSO #Starts patrol as Sheriff's Office
/patrolUSM #Starts patrol as US Marshal
/patrolST #Starts patrol as State Trooper
/endpatrol #Ends patrol regardless of department

Further integration with QBCore and other frameworks as time moves on, for now I'm happy with it.
