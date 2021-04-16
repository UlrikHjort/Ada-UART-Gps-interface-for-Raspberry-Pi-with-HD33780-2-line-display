---------------------------------------------------------------------------
--            Raspberry Pi I/O System Call Interface
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
with Interfaces.C;
with Types; use Types;

package IO is
   package C renames Interfaces.C;
   
   type Mode is (O_RDONLY, O_WRONLY,  O_RDWR);
   for Mode'Size use Interfaces.C.int'Size;
   for Mode use (O_RDONLY => 0, O_WRONLY => 1,  O_RDWR => 2);
   
   --------------------------------------------------------------------
   --
   -- Open
   --
   --------------------------------------------------------------------       
   function Open(Filename : String; Flags : Mode) return C.Int;
   
   --------------------------------------------------------------------
   --
   -- Perror
   --
   --------------------------------------------------------------------       
   procedure Perror(Error_Message : String); 
   
   --------------------------------------------------------------------
   --
   -- Ioctl
   --
   --------------------------------------------------------------------       
   function Ioctl(Handle : C.Int; Request : C.Unsigned_Long; Addr : C.Int) return Integer;
   
   --------------------------------------------------------------------
   --
   -- Write
   --
   --------------------------------------------------------------------       
   function Write(Handle : C.Int; Buffer : Byte_Buffer; Length : C.Int) return Integer;
   
   --------------------------------------------------------------------
   --
   -- Read
   --
   --------------------------------------------------------------------       
   function Read(Handle : C.Int; Buffer : Byte_Buffer; Length : C.Int) return Integer;
   
   --------------------------------------------------------------------
   --
   -- Close
   --
   --------------------------------------------------------------------       
   function Close(Handle : C.Int) return Integer;
end IO;
