MsgRoom = {}

-- 构造函数;
function MsgRoom:Init()
	self._EventRegister = EventRegister.new();

    self._EventRegister:RegisterEvent( "ER",                self, self.cbEnterRoom );
    self._EventRegister:RegisterEvent( "LR",                self, self.cbLeaveRoom );
    self._EventRegister:RegisterEvent( "RRM",               self, self.cbReleasePrvRoom );
    self._EventRegister:RegisterEvent( "DDZ_RE",            self, self.cbDDZReliveRoom );
    
    
    self._EventRegister:RegisterEvent( "CPRM=>PLS",         self, self.cbCreatePrivateRoom );
    self._EventRegister:RegisterEvent( "EPRM=>PLS",         self, self.cbEnterPrivateRoom );

end

function MsgRoom:cbEnterRoom( fes_sid, msg_enter_room )


    nlinfo("MsgRoom:cbEnterRoom");
	
end

function MsgRoom:cbLeaveRoom( fes_sid, msgin )

    local uid       = msgin:rint64();
    local player    = PlayerMgr:GetPlayer(uid);
    
    if player~=nil then
        local room = RoomMgr:GetRoom(player.RoomID);
        
        if room~=nil then
            room:LeaveRoom(uid);
        end
    end
    nlinfo("MsgRoom:cbLeaveRoom");
	
end

function MsgRoom:cbCreatePrivateRoom( sch_sid, msgin )
    local uid           = msgin:rint();
    local prv_room_id   = msgin:rint();
    local pls_sid       = msgin:rint();
    local msg_cpr       = msgin:rtable();
--    local room_type     = msgin:rstring();

    nlwarning("MsgRoom:cbCreatePrivateRoom");
    
    nlinfo(uid);
    nlinfo(prv_room_id);
    nlinfo(pls_sid);
    PrintTable(msg_cpr);
	
    RoomMgr:CreatePrivateRoom(uid, prv_room_id, msg_cpr);
end

function MsgRoom:cbEnterPrivateRoom( sch_sid, msgin )
    local uid           = msgin:rint();
    local pls_sid       = msgin:rint();
    local prv_room_id   = msgin:rint();
    local room_type     = msgin:rstring();
    
    nlinfo("MsgRoom:cbEnterPrivateRoom");
    
    nlinfo(uid);
    nlinfo(prv_room_id);
    nlinfo(pls_sid);
    nlinfo(room_type);
    
    if GetServiceID()~=pls_sid then
        nlwarning("GetServiceID()~=pls_sid");
        
    else
        RoomMgr:EnterPrivateRoom(uid, prv_room_id, room_type);
    end
end

function MsgRoom:cbReleasePrvRoom( fes_sid, msgin )

    local uid       = msgin:rint64();
    local player    = PlayerMgr:GetPlayer(uid);
    
    if player~=nil then
        local room = RoomMgr:GetRoom(player.RoomID);
        
        if room~=nil then
            room:RelieveForceRoom(uid);
        end
    end
end

function MsgRoom:cbDDZReliveRoom( fes_sid, msgin )

    local uid       = msgin:rint64();
    local player    = PlayerMgr:GetPlayer(uid);
    
    if player~=nil then
        local room = RoomMgr:GetRoom(player.RoomID);
        
        if room~=nil then
            
            local msg_bool = msgin:rpb("PB.MsgBool");
            room:RelieveRequestRoom(uid, msg_bool.value);
        end
    end
end



--释放函数
function MsgRoom:Release()
    self._EventRegister:UnRegisterAllEvent();
end


return MsgRoom;
