#include "component.hpp"

(["trackingInterval",[0,0]] call mitm_common_fnc_getMissionConfigEntry) params ["_intervalMin","_intervalMax"];
private _averageInterval = round ((_intervalMin+_intervalMax)/2/60);


private _theBriefcase = format ["
The Briefcase contains a tracking device. Every %1 minutes a marker will appear on the map, visible to everyone.<br/>
<br/>
Should the Courier lose possession of the Briefcase, the marker will appear %2 times as often. While the Briefcase is in a vehicle, the marker will appear %3 times as often.
",_averageInterval,1/(["trackingIntervalFactorNoCourier",0] call mitm_common_fnc_getMissionConfigEntry),1/(["trackingIntervalFactorVehicle",0] call mitm_common_fnc_getMissionConfigEntry)];

player createDiaryRecord ["Diary", ["The Briefcase", _theBriefcase]];


private _theCourier = "
The Courier is on his way to deliver a briefcase to a business associate. On his way he will have to make a stop at 4 of the 6 marked locations in non-specific order.<br/>
<br/>
He has to hurry, because there are three outside parties that have taken an interest in the briefcase. They are armed to the teeth, while the courier only has basic self defense.<br/>
<br/>
The Courier's loyalty to his associate is questionable and he might join his enemies under threat of violence.
";

player createDiaryRecord ["Diary", ["The Courier", _theCourier]];
