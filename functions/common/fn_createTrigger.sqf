#include "component.hpp"

/*
*   Creates local trigger on server
*/

params ["_triggerAttachObject",["_triggerArea",[20,20,0,false]],["_triggerActivation",["ANY","PRESENT",true]],["_triggerCondition",{true}],["_onTriggerActivate",{}],["_onTriggerDeactivate",{}],["_statementParams",[]]];

private _pos = if (_triggerAttachObject isEqualType objNull) then {getPos _triggerAttachObject} else {_triggerAttachObject};

private _trigger = createTrigger ["EmptyDetector",_pos,false];

_trigger setTriggerArea _triggerArea;
_trigger setTriggerActivation _triggerActivation;

if (_triggerAttachObject isEqualType objNull) then {
    _trigger attachTo [_triggerAttachObject,[0,0,0],""];
    _trigger setVariable ["mitm_common_triggerAttachObject",_triggerAttachObject];
};
_trigger setVariable ["mitm_common_triggerCondition",_triggerCondition];
_trigger setVariable ["mitm_common_onTriggerActivate",_onTriggerActivate];
_trigger setVariable ["mitm_common_onTriggerDeactivate",_onTriggerDeactivate];
_trigger setVariable ["mitm_common_statementParams",_statementParams];

_trigger setTriggerStatements [
    "this && {[thisTrigger,thisList,this] call (thistrigger getVariable ['mitm_common_triggerCondition',{true}])}",
    "[thisTrigger,thisList,this,thisTrigger getVariable ['mitm_common_statementParams',[]]] call (thisTrigger getVariable ['mitm_common_onTriggerActivate',{}])",
    "[thisTrigger,thisList,this,thisTrigger getVariable ['mitm_common_statementParams',[]]] call (thisTrigger getVariable ['mitm_common_onTriggerDeactivate',{}])"
];

_trigger
