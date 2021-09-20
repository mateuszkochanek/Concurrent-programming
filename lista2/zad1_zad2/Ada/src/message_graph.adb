package body Message_Graph is
   
   protected body Pipe is 
      entry Set (V : in Packet_Access) when not Is_Full is
      begin
         Value := V;
         Is_Full := True;
      end Set;

      entry Get (V : out Packet_Access) when Is_Full is
      begin
         V := Value;
         Is_Full := False;
      end Get;
   end Pipe;
   

end message_graph;
