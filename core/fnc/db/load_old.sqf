
/* ----------------------------------------------------------------------------
Function: btc_fnc_db_load_old

Description:
    Fill me when you edit me !

Parameters:
    _id - []
    _initialized - []
    _spawn_more - []
    _occupied - []
    _data_units - []
    _has_ho - []
    _ho_units_spawned - []
    _ieds - []
    _has_suicider - []

Returns:

Examples:
    (begin example)
        _result = [] call btc_fnc_db_load_old;
    (end)

Author:
    Giallustio

---------------------------------------------------------------------------- */


private _name = worldName;

setDate (profileNamespace getVariable [format ["btc_hm_%1_date", _name], date]);

//CITIES
private _cities_status = profileNamespace getVariable [format ["btc_hm_%1_cities", _name], []];

{
    _x params ["_id", "_initialized", "_spawn_more", "_occupied", "_data_units", "_has_ho", "_ho_units_spawned", "_ieds", "_has_suicider"];

    private _city = btc_city_all select _id;

    _city setVariable ["initialized", _initialized];
    _city setVariable ["spawn_more", _spawn_more];
    _city setVariable ["occupied", _occupied];
    _city setVariable ["data_units", _data_units];
    _city setVariable ["has_ho", _has_ho];
    _city setVariable ["ho_units_spawned", _ho_units_spawned];
    _city setVariable ["ieds", _ieds];
    _city setVariable ["has_suicider", _has_suicider];

    if (btc_debug) then {//_debug

        if (_city getVariable ["occupied",false]) then {(_city getVariable ["marker", ""]) setmarkercolor "colorRed";} else {(_city getVariable ["marker", ""]) setmarkercolor "colorGreen";};
        (_city getVariable ["marker", ""]) setmarkertext format ["loc_%3 %1 %2 - [%4]", _city getVariable "name", _city getVariable "type", _id, _occupied];

        diag_log format ["ID: %1", _id];
        diag_log format ["data_city: %1", _x];
        diag_log format ["LOAD: %1 - %2", _id, _occupied];
    };
} forEach _cities_status;

//HIDEOUT
private _array_ho = profileNamespace getVariable [format ["btc_hm_%1_ho", _name], []];

{
    _x params ["_pos", "_id_hideout","_rinf_time", "_cap_time", "_id", "_markers_saved"];

    private _city = btc_city_all select _id;

    private _hideout = [_pos] call btc_fnc_mil_create_hideout_composition;
    clearWeaponCargoGlobal _hideout;clearItemCargoGlobal _hideout;clearMagazineCargoGlobal _hideout;

    _city setpos _pos;
    if (btc_debug) then    {deleteMarker format ["loc_%1", _id];};
    deleteVehicle (_city getVariable ["trigger_player_side",objNull]);
    private _radius_x = btc_hideouts_radius;
    private _radius_y = btc_hideouts_radius;

    [_pos, _radius_x, _radius_y, _city, _city getVariable "occupied", _city getVariable "name", _city getVariable "type", _id] call btc_fnc_city_trigger_player_side;

    _city setVariable ["RadiusX", _radius_x];
    _city setVariable ["RadiusY", _radius_y];

    _hideout setVariable ["id", _id_hideout];
    _hideout setVariable ["rinf_time", _rinf_time];
    _hideout setVariable ["cap_time", _cap_time];
    _hideout setVariable ["assigned_to", _city];

    _hideout addEventHandler ["HandleDamage", btc_fnc_mil_hd_hideout];

    private _markers = [];
    {
        _x params ["_pos", "_marker_name"];

        private _marker = createmarker [format ["%1", _pos], _pos];
        _marker setmarkertype "hd_warning";
        _marker setMarkerText _marker_name;
        _marker setMarkerSize [0.5, 0.5];
        _marker setMarkerColor "ColorRed";
        _markers pushBack _marker;
    } forEach _markers_saved;

    _hideout setVariable ["markers", _markers];

    if (btc_debug) then {
        //Marker
        createmarker [format ["btc_hideout_%1", _pos], _pos];
        format ["btc_hideout_%1", _pos] setmarkertype "mil_unknown";
        format ["btc_hideout_%1", _pos] setMarkerText format ["Hideout %1", btc_hideouts_id];
        format ["btc_hideout_%1", _pos] setMarkerSize [0.8, 0.8];
    };

    if (btc_debug_log) then {diag_log format ["btc_fnc_mil_create_hideout: _this = %1 ; POS %2 ID %3", _x, _pos, btc_hideouts_id];};

    btc_hideouts_id = btc_hideouts_id + 1;
    btc_hideouts pushBack _hideout;
} forEach _array_ho;

private _ho = profileNamespace getVariable [format ["btc_hm_%1_ho_sel", _name], 0];
btc_hq = btc_hideouts select _ho;

if (count btc_hideouts == 0) then {[] spawn btc_fnc_final_phase;};

//CACHE

btc_cache_markers = [];

private _array_cache = profileNamespace getVariable [format ["btc_hm_%1_cache", _name], []];

btc_cache_pos = _array_cache select 0;
btc_cache_n = _array_cache select 1;
btc_cache_info = _array_cache select 2;

call btc_fnc_cache_create;

{
    _x params ["_pos", "_marker_name"];

    private _marker = createmarker [format ["%1", _pos], _pos];
    _marker setmarkertype "hd_unknown";
    _marker setMarkerText _marker_name;
    _marker setMarkerSize [0.5, 0.5];
    _marker setMarkerColor "ColorRed";
    btc_cache_markers pushBack _marker;
} forEach (_array_cache select 3);

//FOB
private _fobs = profileNamespace getVariable [format ["btc_hm_%1_fobs", _name], []];
private _fobs_loaded = [[], []];

{
    _x params ["_fob_name", "_pos"];

    createmarker [_fob_name, _pos];
    _fob_name setMarkerSize [1, 1];
    _fob_name setMarkerType "b_hq";
    _fob_name setMarkerText _fob_name;
    _fob_name setMarkerColor "ColorBlue";
    _fob_name setMarkerShape "ICON";
    private _fob_structure = createVehicle [btc_fob_structure, _pos, [], 0, "NONE"];
    private _flag = createVehicle [btc_fob_flag, _pos, [], 0, "NONE"];
    _flag setVariable ["btc_fob", _fob_name];
    (_fobs_loaded select 0) pushBack _fob_name;
    (_fobs_loaded select 1) pushBack _fob_structure;
} forEach (_fobs select 0);
btc_fobs = _fobs_loaded;

//REP
private _global_reputation = profileNamespace getVariable [format ["btc_hm_%1_rep", _name], 0];

//Objects
private _objs = profileNamespace getVariable [format ["btc_hm_%1_objs", _name], []];
{
    [_x] call btc_fnc_db_loadObjectStatus;
} forEach _objs;

//Player Markers
private _markers_properties = profileNamespace getVariable [format ["btc_hm_%1_markers", _name], []];
{
    _x params ["_markerText", "_markerPos", "_markerColor", "_markerType", "_markerSize", "_markerAlpha", "_markerBrush", "_markerDir", "_markerShape"];

    private _marker = createMarker [format ["_USER_DEFINED #0/%1/1", _forEachindex], _markerPos];
    _marker setMarkerText _markerText;
    _marker setMarkerColor _markerColor;
    _marker setMarkerType _markerType;
    _marker setMarkerSize _markerSize;
    _marker setmarkerAlpha _markerAlpha;
    _marker setmarkerBrush _markerBrush;
    _marker setmarkerDir _markerDir;
    _marker setmarkerShape _markerShape;
} forEach _markers_properties;
