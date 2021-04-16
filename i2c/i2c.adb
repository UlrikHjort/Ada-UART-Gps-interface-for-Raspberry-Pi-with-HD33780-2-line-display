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
with Io;

package body i2c is
   
   Selected_Device : Positive := 1;
   
   --------------------------------------------------------------------
   --
   -- Init
   --
   --------------------------------------------------------------------       
   function Init(Device : Devices) return Integer is
	 
   begin 
      Selected_Device := Device+1;
      return  0;      	 
   end Init;	    
   
   
   --------------------------------------------------------------------
   --
   -- Open
   --
   --------------------------------------------------------------------       
   function Open(Addr : C.Int) return C.Int is
      use C; -- For < operator
      Handle : C.Int := 0;
      I2C_SLAVE	: constant C.Unsigned_Long := 16#0703#;	
      
   begin
      Handle := Io.Open(Device(Selected_Device).all, Io.O_RDWR);

      if Handle < 0 then
	 Io.Perror("Failed to open the i2c bus"); 
	 return 0;
      end if;
      
      if Io.Ioctl(Handle, I2C_SLAVE, Addr) < 0 then
	 Io.Perror("Failed to acquire bus access and/or talk to slave.\n"); 
	 return 0;	 
      end if;
	
      return Handle;
   end Open;
   
   
   --------------------------------------------------------------------
   --
   -- Read
   --
   --------------------------------------------------------------------       
   function Read(Addr : C.Int; Buffer : Byte_Buffer; Length : C.Int)  return Integer is
	 
      Handle : constant C.Int := Open(Addr);
      R : Integer := 0;      
   begin
      R := Io.Read(Handle, Buffer, Length);
      R := Io.Close(Handle);
      return R;      
   end Read;	 
   
   
   --------------------------------------------------------------------
   --
   -- Write
   --
   --------------------------------------------------------------------       
   function Write(Addr : C.Int; Buffer : Byte_Buffer; Length : C.Int)  return Integer is
      
      Handle : constant C.Int := Open(Addr);
      R : Integer := 0;
   begin
      R := Io.Write(Handle, Buffer, Length);
      R := Io.Close(Handle);
      return R;
   end Write;

end i2c;

