MsgLogin = {}

function MsgLogin:Init()
	self._EventRegister = EventRegister.new();
    self._EventRegister:RegisterEvent( "SyncData",          self, self.cbSyncData );
    self._EventRegister:RegisterEvent( "ClientOffline",     self, self.cbClientOffline );
    
end

function MsgLogin:cbSyncData( schid, msg_sdata_1 )

    local uid           = msg_sdata_1:rint64();
    local fesid         = msg_sdata_1:rint32();
    
    local player_helper = PlayerMgr:LoadDBPlayer(uid);
    
    if player_helper~=nil then
        
        player_helper.ConFES = fesid;
        PrintTable(player_helper);
        
        -- 通知FES保存玩家在哪个PLS
        msg_sdata_1:invert();
        BaseService:Send( player_helper.ConFES, msg_sdata_1);
        
        -- 发送玩家数据给客户端
        BaseService:SendToClient( player_helper, "SyncPlayerInfo",
                                  "PB.MsgPlayerInfo", player_helper.PlayerDataHelper:ToMsg() )
    end
	
end

function MsgLogin:cbClientOffline( fesid, msgin )

    local uid       = msgin:rint();
    local player    = PlayerMgr:GetPlayer(uid);

    if player~=nil then
        player:Offline();
	    nlinfo("MsgLogin:cbClientOffline UID:"..uid);
    end
end

--释放函数
function MsgLogin:Release()
    self._EventRegister:UnRegisterAllEvent();
end


return MsgLogin;
