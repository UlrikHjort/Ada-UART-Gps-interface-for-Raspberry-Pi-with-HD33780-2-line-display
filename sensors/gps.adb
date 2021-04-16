---------------------------------------------------------------------------
--           Raspberry Pi NMEA 0183 UART GPS interface
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
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;

package body Gps is
      
   Uart_Handle  : File_Type;   
   
   Initialized : Boolean := False;
   
   ---------------------------------------------------------
   -- Local methods:
   ---------------------------------------------------------         
      
   -----------------------------------------------------------------------------------------
   --
   -- Parse NMEA 0183 GPGGA string, extract and return Time, Lat and Lon
   --
   -----------------------------------------------------------------------------------------    
   procedure Parse_GPGGA(S : in String; Time : out String; Lat : out String; Lon : out String) is 
      
      type State_T is (S_START, S_TIME, S_LAT, S_NS, S_LON, S_EW, S_END);
      
      State : State_T := S_START;
      
      I : Integer := 0;
      
   begin
      --Put_Line(S);
      for C in S'First .. S'Last loop

	 case State is
	    
	    when S_START =>
	       if S(C) = ',' then
		  State := S_TIME;		 
		  I := 0;		  
	       end if;	       
	       
	    when S_TIME =>
	       if S(C) = ',' then
		  State := S_LAT;
		  I := 0;
	       else
		  Time(I) := S(C);
	       end if;	       	       
	       
	    when S_LAT =>
	       if S(C) = ',' then
		  State := S_NS;
		  LAT(I) := ' ';
	       else
		  LAT(I) := S(C);
	       end if;
	       
	    when S_NS =>
	       if S(C) = ',' then
		  State := S_LON;
		  I := 0;
	       else
		  LAT(I) := S(C);
	       end if;	       
	       
	    when S_LON =>
	       if S(C) = ',' then
		  State := S_EW;
		  LON(I) := ' ';		  		  
	       else
		  LON(I) := S(C);		  
	       end if;	       	       
	       
	    when S_EW =>
	       if S(C) = ',' then
		  State := S_END;
		  I := 0;
	       else
		  LON(I) := S(C);
	       end if;	       	       
	    when S_END => null;
	 end case;
	 I := I + 1;
      end loop;
   end Parse_GPGGA;
      
   -----------------------------------------------------------------------------------------
   --
   -- Read NMEA data from gps device, return Time, Lat and Lon
   --
   -----------------------------------------------------------------------------------------       
   procedure Read(Time : out String; Lat : out String; Lon : out String) is
      
      Buffer : Character;
      
      LF : constant Character := Character'Val(10);
      
      NMEA_0183_Sentence_Max_Length : constant Positive := 79+1;
      
      S : String(1 .. NMEA_0183_Sentence_Max_Length) := (others => Character'Val(0));
      I : Positive := 1;
      
      Except : exception;
      
   begin      
      
     if not Initialized then
         raise Except with "Error: Gps device has not been initialized";
      end if;
            
      Time := (others => Character'Val(0));      
      Lat  := (others => Character'Val(0));            
      Lon  := (others => Character'Val(0));                  	             

      loop
	 Buffer := Character'Input (Stream (Uart_Handle));
	 S(I) := Buffer;
	 I := I + 1; 
	 
	 if Buffer = LF then
	    if Index (S, "$GPGGA") > 0 then
	       Parse_GPGGA(S, Time, Lat, Lon);
    	       exit;
	    else -- Not GPGGA so clear buffer and read next line from GPS
	       I := 1;
	       S := (others => Character'Val(0));	    
	    end if;
	 end if;	 	 
      end loop;
     
   exception
      when End_Error =>
	 if Is_Open(Uart_Handle) then
	    Close (Uart_Handle);
	    Initialized := false;	    
	 end if;      
   end Read;
   
   
   -----------------------------------------------------------------------------------------
   --
   -- Init Gps UART device
   --
   -----------------------------------------------------------------------------------------       
   procedure Init(Device : String) is
             
   begin
      Open(File => Uart_Handle,  Mode => In_File,  Name => Device);      
      Initialized := true;
   end Init;
   
   
   ---------------------------------------------------------
   -- Global methods:
   ---------------------------------------------------------         
         
   -----------------------------------------------------------------------------------------
   --
   -- De init and close device
   --
   -----------------------------------------------------------------------------------------       
   procedure De_Init is
      
   begin
      Close (Uart_Handle);      
      Initialized := false;      
   end De_Init;
   
   -----------------------------------------------------------------------------------------
   --
   -- Get time
   --
   -----------------------------------------------------------------------------------------       
   procedure Get(Time : out String) is
      
      Lat : String(Lat_Len) := (others => Character'Val(0));            
      Lon : String(Lon_Len) := (others => Character'Val(0));                        
      
   begin
      Read(Time, Lat, Lon);                  
   end Get;
   
   -----------------------------------------------------------------------------------------
   --
   -- Get Lat and Lon
   --
   -----------------------------------------------------------------------------------------       
   procedure Get(Lat : out String; Lon : out String) is
      
      Time : String(Time_Len) := (others => Character'Val(0));      
      
   begin
      Read(Time, Lat, Lon);            
   end Get;
   
   -----------------------------------------------------------------------------------------
   --
   -- Get time, Lat and Lon
   --
   -----------------------------------------------------------------------------------------    
   procedure Get(Time : out String; Lat : out String; Lon : out String) is
      
   begin
      Read(Time, Lat, Lon);      
   end Get;   
      
end Gps;


