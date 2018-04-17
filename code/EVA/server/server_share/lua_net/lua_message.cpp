#include "lua_message.h"

void forLuaMessageForceLink()
{
    nlwarning("forLuaMessageForceLink");
}

namespace bin
{
    BEGIN_SCRIPT_CLASS( LuaMessage, CLuaMessage )

    DEFINE_CLASS_FUNCTION( invert, void, ())
    {
        obj->m_Msg.invert();
        return 1;
    }

    DEFINE_CLASS_FUNCTION( name, std::string, ())
    {
        r = obj->m_Msg.getName();
        return 1;
    }

    DEFINE_CLASS_FUNCTION( clear, void, (std::string name))
    {
        obj->m_Msg.clear();
        return 1;
    }

    DEFINE_CLASS_FUNCTION( wbuffer, void, (const std::string& buff, int len))
    {
        sint32  serial_val=len;
        obj->m_Msg.serial(serial_val);
        obj->m_Msg.serialBuffer((uint8*)buff.c_str(), len);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( wstring, void, (std::string& str))
    {
        obj->m_Msg.serial(str);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( wint, void, (sint64 in_val))
    {
        obj->m_Msg.serial(in_val);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( wint32, void, (sint32 in_val))
    {
        obj->m_Msg.serial(in_val);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( wint64, void, (sint64 in_val))
    {
        obj->m_Msg.serial(in_val);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( wuint32, void, (lua_Integer in_val))
    {
        uint32  serial_val=in_val;
        obj->m_Msg.serial(serial_val);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( rint32, sint32, ())
    {
        nlassert(obj->m_Msg.isReading());
        obj->m_Msg.serial(r);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( ruint32, lua_Integer, ())
    {
        nlassert(obj->m_Msg.isReading());
        uint32  result=0;
        obj->m_Msg.serial(result);
        r = result;
        return 1;
    }

    DEFINE_CLASS_FUNCTION( rint64, sint64, ())
    {
        nlassert(obj->m_Msg.isReading());
        obj->m_Msg.serial(r);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( rint, sint64, ())
    {
        nlassert(obj->m_Msg.isReading());
        obj->m_Msg.serial(r);
        return 1;
    }

    DEFINE_CLASS_FUNCTION( rstring, std::string, ())
    {
        nlassert(obj->m_Msg.isReading());
        obj->m_Msg.serial(r);
        return 1;
    }

    DEFINE_STATIC_FUNCTION(NewInstance, CLuaMessage*, (std::string name))
    {
        r = new CLuaMessage(name);
        r->GetScriptObject().SetDelByScr(true);

        return 1;
    }

    END_SCRIPT_CLASS()
}

