//TESH.scrollpos=0
//TESH.alwaysfold=0
library japi requires JapiConstantLib
    native SetHeroLevels        takes code f returns nothing  
    native TeleportCaptain      takes real x, real y returns nothing
    native GetUnitGoldCost      takes integer unitid returns integer

    globals 
        public hashtable ht=InitHashtable()
        private integer key=StringHash("jass")
    endglobals
    
    public function japiDoNothing takes nothing returns nothing 
    
    endfunction
    
    public function GetFuncAddr takes code f returns integer
        call SetHeroLevels(f)
        return LoadInteger(ht,key,0)
    endfunction
    
    public function Call takes string str returns nothing
        call UnitId(str)
    endfunction
    
    public function initializePlugin takes nothing returns integer
        call ExecuteFunc("japiDoNothing")
        call StartCampaignAI( Player(PLAYER_NEUTRAL_AGGRESSIVE), "callback" )
        call Call(I2S(GetHandleId(ht)))
        call SaveStr(ht,key,0,"(I)V")
        call SaveInteger(ht,key,1,GetFuncAddr(function japiDoNothing))
        call Call("SaveFunc")
        call ExecuteFunc("japiDoNothing")
        return 0
    endfunction
endlibrary
<?
    variable=''
    init_variable=''
    for i=1,32 do
        variable=variable..' integer array i_'..i..'\n'
        init_variable=init_variable..' set i_'..i..'[8191]=0\n'
    end
?>

library JapiConstantLib 
    globals
        <?=variable?>
    endglobals
    function JapiConstantLib_init_memory takes nothing returns nothing
        <?=init_variable?>
    endfunction
    function JapiConstantLib_init takes nothing returns integer 
        call ExecuteFunc("JapiConstantLib_init_memory")
        return 1
    endfunction
endlibrary


#define SetCameraBounds(a,b,c,d,e,f,g,h) JapiConstantLib_init() YDNL call japi_initializePlugin() YDNL call SetCameraBounds(a,b,c,d,e,f,g,h)
