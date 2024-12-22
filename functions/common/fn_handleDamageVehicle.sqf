params ["_vehicle"];


_vehicle addEventHandler ["HandleDamage", {
    params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

    // prevent damage explosions
    if ((_damage > .88 && _hitPoint == "hitHull") || (_damage > .88 && _hitPoint == "") || damage _unit > .88) then {
        _damage = .88;
    };

    // hint ("damage is " + str _damage + " - hitpoint is " + str _hitPoint);
    // diag_log format ["damage %1 - hitpoint %2 - vehicle alive %3", _damage, _hitPoint, alive _unit];
    
    _damage
}];