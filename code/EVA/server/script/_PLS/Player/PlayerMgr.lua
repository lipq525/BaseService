PlayerMgr = {}

-- 初始化函数
function PlayerMgr:Init()
	self.playerMap      = Map:new();


end


function PlayerMgr:Count()
    return self.playerMap:Count();
end

function PlayerMgr:GetPlayer( _uid )

    local player = self.playerMap:Find(_uid);
    
    if player~=nil then
        player.LastUpdateTime = TimerMgr:GetTime();
    end
    
    return player
end

function PlayerMgr:LoadDBPlayer( _uid )
    
    local tb_playerinfo = DBMgr:LoadPlayerInfo(_uid);
    
    if tb_playerinfo==nil then
        if DBMgr:CreatePlayer(_uid)==true then
            tb_playerinfo = DBMgr:LoadPlayerInfo(_uid);
        end
    end
    
    if tb_playerinfo~=nil then
        local player_helper    = PlayerHelper:new();
        
        player_helper.UID               = _uid;
        player_helper.PlayerDataHelper  = tb_playerinfo;
        
        self.playerMap:Insert(_uid, player_helper);
        return player_helper;
    end
    
    return nil;
end

-- 从缓存中移除玩家
function PlayerMgr:RemovePlayer( _uid )
    local player = self.playerMap:Find(_uid);
    
    if player~=nil then
        player:Release();
        self.playerMap:Remove(_uid);
    end
end

return PlayerMgr
