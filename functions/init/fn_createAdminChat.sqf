#include "component.hpp"

if (!isServer) exitWith {};

mitm_adminMessages_channel = radioChannelCreate [[0.9,0.1,0.1,1],"MitM","MitM",[],true];
publicVariable "mitm_adminMessages_channel";
