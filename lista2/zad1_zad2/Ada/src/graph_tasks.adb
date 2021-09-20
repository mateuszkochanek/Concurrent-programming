with Text_IO; use Text_IO;

package body Graph_Tasks is
   
   task body TaskSource is
      packet : Packet_Access;
      Random_Index : Integer;
      Output_Channels_Count : Integer;
      counter : Integer := 0;
   begin
      reset(gen);
      Output_Channels_Count := Integer(node.outputPipes.Length);
      loop
         select
            accept Send (myPacket : Packet_Access) do
               packet := myPacket;
               counter := counter + 1;
               Messager.Print("Pakiet "&Integer'Image(packet.index)&" jest w wierzcholku 0");
               delay Duration(Integer(random(gen)) mod Sending_Delay);
               packet.visitedNodes.Append(node.index);
               node.servedPackets.Append(packet.index);
               Random_Index := Integer(random(gen)) mod Output_Channels_Count;
               node.outputPipes(Random_Index).Pipe.Set(packet);
            end Send;
         
         end select;
         exit when counter = k;
      end loop;
   end TaskSource;
   
   task body TaskJunction is
      packet : Packet_Access;
      Random_Index : Integer;
      stop : Boolean := False;
      Output_Channels_Count : Integer;
      Input_Channels_Count : Integer;
      isTrapped : Boolean := False;
   begin
      reset(gen);
      Output_Channels_Count := Integer(node.outputPipes.Length);
      Input_Channels_Count := Integer(node.inputPipes.Length);
      loop
         for channel of node.inputPipes loop
            select
               channel.Pipe.Get(packet);
               Messager.Print("Pakiet "&Integer'Image(packet.index)&" jest w wierzcholku" & Integer'Image(node.index));
               if packet.ttl = 1 then
                  Messager.Print("Pakiet "&Integer'Image(packet.index)&" umiera w wierzcholku" & Integer'Image(node.index));
                  packet.visitedNodes.Append(node.index);
                  node.servedPackets.Append(packet.index);
               elsif isTrapped then
                  isTrapped := False;
                  Messager.Print("Pakiet "&Integer'Image(packet.index)&" wpadl w pulapke w wierzcholku" & Integer'Image(node.index));
                  packet.visitedNodes.Append(node.index);
                  node.servedPackets.Append(packet.index);
               else
                  packet.ttl := packet.ttl - 1;
                  delay Duration(Integer(random(gen)) mod Sending_Delay);
                  Random_Index := Integer(random(gen)) mod Output_Channels_Count;
                  packet.visitedNodes.Append(node.index);
                  node.servedPackets.Append(packet.index);
                  node.outputPipes(Random_Index).Pipe.Set(packet);
               end if;
            else
               null;
            end select;
         end loop;
         select 
            accept Terminate_Junction  do
               stop := True;
            end Terminate_Junction;
         or 
            accept Trap_Setup  do
               isTrapped := True;
            end Trap_Setup;
         else
            null;
         end select;
         
         exit when stop;
      end loop;
   end TaskJunction;
   
   task body TaskOutlet is
      packet : Packet_Access;
      stop : Boolean := False;
   begin
      loop
         delay Duration(Integer(random(gen)) mod Sending_Delay);
         for channel of node.inputPipes loop
            select
               channel.Pipe.Get(packet);
               packet.visitedNodes.Append(node.index);
               node.servedPackets.Append(packet.index);
               Messager.Print("Pakiet "&Integer'Image(packet.index)&" zostal odebrany");
            else
               null;
            end select;
         end loop;
         select 
            accept Terminate_Outlet  do
                  stop := True;
            end Terminate_Outlet;
         else
            null;
         end select;
         exit when stop;
      end loop;
   end TaskOutlet;
   
   task body Messager is
   begin
      loop
         select
            accept Print (msg : in String) do
               Put_Line (msg);
            end Print;
         or
            terminate;
         end select;
      end loop;
   end Messager;
   
   task body TaskHunter is
      stop : Boolean := False;
      junctions_len : Integer;
      index : Integer; 
   begin
      junctions_len := Integer(junctions.Length);
      loop
         delay Duration(15);
         index := (Integer(random(gen)) mod junctions_len);
         junctions.all(index).Trap_Setup;
         select 
            accept Terminate_Hunter  do
                  stop := True;
            end Terminate_Hunter;
         else
            null;
         end select;
         exit when stop;
      end loop;
   end TaskHunter;
   
   
end Graph_Tasks;
