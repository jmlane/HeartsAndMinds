
/* ----------------------------------------------------------------------------
Function: btc_fnc_info_ask

Description:
    ACE Interaction action handler for questioning people.

Parameters:
    _target - Target of the interaction. [Object]
    _player - The player who performed the interaction. [Object]
    _args - Custom arguments. [Array]:
        0: _isInterrogation - Is a captive being questioned? [Boolean]

Returns:
    [Nothing]

Examples:
    (begin example)
        _action = [
            "Interrogate_intel",
            localize "STR_BTC_HAM_ACTION_INTEL_INTERROGATE","\a3\Ui_f\data\GUI\Cfg\CommunicationMenu\instructor_ca.paa",
            btc_fnc_info_ask,
            {Alive (_this select 0) && {captive (_this select 0)} && {[_this select 0] call ace_common_fnc_isAwake}},
            nil,
            [true]
        ] call ace_interact_menu_fnc_createAction;
    (end)

Author:
    Giallustio, jmlane

---------------------------------------------------------------------------- */

params [
    ["_target", objNull, [objNull]],
    ["_player", player, [objNull]],
    ["_args", [], [[]]]
];

_args params [
    ["_isInterrogation", false, [false]]
];

if !(_target call ace_medical_fnc_isInStableCondition) exitWith {
    private _complain = selectRandom [
        localize "STR_BTC_HAM_CON_INFO_ASK_WOUNDED1", //Help me!
        localize "STR_BTC_HAM_CON_INFO_ASK_WOUNDED2", //I am suffering!
        localize "STR_BTC_HAM_CON_INFO_ASK_WOUNDED3", //Injure!
        localize "STR_BTC_HAM_CON_INFO_ASK_WOUNDED4"  //I have open wound!
    ];
    [name _target, _complain] call btc_fnc_showSubtitle;
};

if ((_target getVariable ["btc_already_asked", false]) || (_target getVariable ["btc_already_interrogated", false])) exitWith {
    [name _target, localize "STR_BTC_HAM_CON_INFO_ASK_ALLREADYANS"] call btc_fnc_showSubtitle; //I already answered to your question!
};

if ((round random 3) >= 2 || !_isInterrogation) then {
    _target setVariable ["btc_already_asked", true];
    if (_isInterrogation) then {_target setVariable ["btc_already_interrogated", true, true];};
};


//NO < 200 . FAKE < 600 . REAL > 600

btc_int_ask_data = nil;
["btc_global_reputation"] remoteExecCall ["btc_fnc_int_ask_var", 2];

[{!(isNil "btc_int_ask_data")},
{
    params [
        ["_target", objNull, [objNull]],
        ["_player", player, [objNull]],
        ["_isInterrogation", false, [false]]
    ];

    private _rep = btc_int_ask_data;

    private _chance = (random 300) + (random _rep) + _rep/2;
    private _info_type = switch !(_isInterrogation) do {
        case (_chance < 200) : {"NO"};
        case (_chance >= 200 && _chance < 600) : {"FAKE"};
        default {"REAL"};
    };

    if (_info_type isEqualTo "NO") exitWith {
        [name _target, localize "STR_BTC_HAM_CON_INFO_ASK_NOINFO"] call btc_fnc_showSubtitle; //I've no information for you
    };

    btc_int_ask_data = nil;
    [8] remoteExecCall ["btc_fnc_int_ask_var", 2];

    [{!(isNil "btc_int_ask_data")},
    {
        params [
            ["_info_type", "REAL", [""]],
            ["_target", objNull, [objNull]],
            ["_player", player, [objNull]]
        ];

        private _final_phase = btc_int_ask_data isEqualTo 0;

        private _info = selectRandomWeighted [
            "TROOPS", 0.4,
            ["HIDEOUT", "TROOPS"] select _final_phase, 0.4,
            "CACHE", 0.2
        ];

        switch (_info) do {
            case "TROOPS" : {
                [name _target, _info_type isEqualTo "REAL"] spawn btc_fnc_info_troops;
            };
            case "HIDEOUT" : {
                [name _target, _info_type isEqualTo "REAL"] spawn btc_fnc_info_hideout_asked;
            };
            case "CACHE" : {
                [name _target, localize "STR_BTC_HAM_CON_INFO_ASK_CACHEMAP"] call btc_fnc_showSubtitle; //I'll show you some hint on the map
                [_player, _info_type isEqualTo "REAL"] remoteExecCall ["btc_fnc_info_cache", 2];
            };
        };
    }, [_info_type, _target, _player]] call CBA_fnc_waitUntilAndExecute;
}, [_target, _player, _isInterrogation]] call CBA_fnc_waitUntilAndExecute;
