#include "component.hpp"

if (!hasInterface) exitWith {};

[{!isNull (findDisplay 46) && {!isNil "mitm_adminMessages_channel"}}, {

    params [["_message",""],["_callSign","MitM"]];

    mitm_adminMessages_channel radioChannelAdd [player];
    mitm_adminMessages_channel radioChannelSetCallsign _callSign;

    player customChat [mitm_adminMessages_channel, _message];

    mitm_adminMessages_channel radioChannelRemove [player];
}, _this] call CBA_fnc_waitUntilAndExecute
