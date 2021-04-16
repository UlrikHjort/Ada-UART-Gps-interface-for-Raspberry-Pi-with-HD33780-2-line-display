---------------------------------------------------------------------------
--                Raspberry Pi I2C interface
-- 
--           Copyright (C) 2021 By Ulrik Hørlyk Hjort
--
--  This Program is Free Software; You Can Redistribute It and/or
--  Modify It Under The Terms of The GNU General Public License
--  As Published By The Free Software Foundation; Either Version 2
--  of The License, or (at Your Option) Any Later Version.
--
--  This Program is Distributed in The Hope That It Will Be Useful,
--  But WITHOUT ANY WARRANTY; Without Even The Implied Warranty of
--  MERCHANTABILITY or FITNESS for A PARTICULAR PURPOSE.  See The
--  GNU General Public License for More Details.
--
-- You Should Have Received A Copy of The GNU General Public License
-- Along with This Program; if not, See <Http://Www.Gnu.Org/Licenses/>.
---------------------------------------------------------------------------
with Types; use Types;

package I2c is
         
   Dev_0 : aliased constant String := "/dev/i2c-0";
   Dev_1 : aliased constant String := "/dev/i2c-1";
   
   type Strings is array (Positive range <>) of access constant String;
   
   Device : constant Strings := (Dev_0'Access,
				 Dev_1'Access);
   
   subtype Devices is Integer range 0 .. 1;
   
   Device_0 :constant Devices := 0;   
   Device_1 :constant Devices := 1;
   
   --------------------------------------------------------------------
   --
   -- Init
   --
   --------------------------------------------------------------------    
   function Init(Device: Devices) return Integer;
   
   --------------------------------------------------------------------
   --
   -- Open
   --
   --------------------------------------------------------------------       
   function Open (Addr : C.Int) return C.Int;
   
   
   --------------------------------------------------------------------
   --
   -- Read
   --
   --------------------------------------------------------------------       
   function Read (Addr : C.Int; Buffer : Byte_Buffer; Length : C.Int) return Integer;
   
   
   --------------------------------------------------------------------
   --
   -- Write
   --
   --------------------------------------------------------------------       
   function Write (Addr : C.Int; Buffer : Byte_Buffer; Length : C.Int) return Integer;   

end I2c;
