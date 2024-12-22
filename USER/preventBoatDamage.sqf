params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

if (!(isNull _source && (_projectile == "") && isNull _instigator)) exitWith {
    nil
};

private _boat = vehicle _unit; // yes, this will even work if _unit is the unmanned boat

private _absSpeed = abs speed _boat;
private _previousDamage = _boat getHitIndex _hitIndex;

private _compoundDamage = _damage + _previousDamage;
if (_compoundDamage < _absSpeed / 50) exitWith { // never destroy a boat from bump speed while  50 km/h
    diag_log format ["allow %1 damage to rubber boat part %2 from bumping into things", _damage, _selection];
    nil;
};

diag_log "prevented damage to rubber boat from bumping into things";