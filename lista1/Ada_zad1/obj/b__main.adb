pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is

   E077 : Short_Integer; pragma Import (Ada, E077, "system__os_lib_E");
   E010 : Short_Integer; pragma Import (Ada, E010, "ada__exceptions_E");
   E015 : Short_Integer; pragma Import (Ada, E015, "system__soft_links_E");
   E027 : Short_Integer; pragma Import (Ada, E027, "system__exception_table_E");
   E042 : Short_Integer; pragma Import (Ada, E042, "ada__containers_E");
   E072 : Short_Integer; pragma Import (Ada, E072, "ada__io_exceptions_E");
   E057 : Short_Integer; pragma Import (Ada, E057, "ada__strings_E");
   E059 : Short_Integer; pragma Import (Ada, E059, "ada__strings__maps_E");
   E063 : Short_Integer; pragma Import (Ada, E063, "ada__strings__maps__constants_E");
   E047 : Short_Integer; pragma Import (Ada, E047, "interfaces__c_E");
   E029 : Short_Integer; pragma Import (Ada, E029, "system__exceptions_E");
   E083 : Short_Integer; pragma Import (Ada, E083, "system__object_reader_E");
   E052 : Short_Integer; pragma Import (Ada, E052, "system__dwarf_lines_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__soft_links__initialize_E");
   E041 : Short_Integer; pragma Import (Ada, E041, "system__traceback__symbolic_E");
   E119 : Short_Integer; pragma Import (Ada, E119, "ada__numerics_E");
   E110 : Short_Integer; pragma Import (Ada, E110, "ada__tags_E");
   E108 : Short_Integer; pragma Import (Ada, E108, "ada__streams_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "system__file_control_block_E");
   E116 : Short_Integer; pragma Import (Ada, E116, "system__finalization_root_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "ada__finalization_E");
   E185 : Short_Integer; pragma Import (Ada, E185, "system__file_io_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "system__storage_pools_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "system__finalization_masters_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "system__storage_pools__subpools_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "system__task_info_E");
   E136 : Short_Integer; pragma Import (Ada, E136, "system__task_primitives__operations_E");
   E008 : Short_Integer; pragma Import (Ada, E008, "ada__calendar_E");
   E006 : Short_Integer; pragma Import (Ada, E006, "ada__calendar__delays_E");
   E178 : Short_Integer; pragma Import (Ada, E178, "ada__real_time_E");
   E181 : Short_Integer; pragma Import (Ada, E181, "ada__text_io_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "system__pool_global_E");
   E214 : Short_Integer; pragma Import (Ada, E214, "system__random_seed_E");
   E164 : Short_Integer; pragma Import (Ada, E164, "system__tasking__initialization_E");
   E152 : Short_Integer; pragma Import (Ada, E152, "system__tasking__protected_objects_E");
   E168 : Short_Integer; pragma Import (Ada, E168, "system__tasking__protected_objects__entries_E");
   E170 : Short_Integer; pragma Import (Ada, E170, "system__tasking__queuing_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "system__tasking__stages_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "message_graph_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "graph_tasks_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E121 := E121 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "graph_tasks__finalize_spec");
      begin
         F1;
      end;
      E188 := E188 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "message_graph__finalize_spec");
      begin
         F2;
      end;
      E168 := E168 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F3;
      end;
      E196 := E196 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__pool_global__finalize_spec");
      begin
         F4;
      end;
      E181 := E181 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "ada__text_io__finalize_spec");
      begin
         F5;
      end;
      E200 := E200 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__storage_pools__subpools__finalize_spec");
      begin
         F6;
      end;
      E190 := E190 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "system__finalization_masters__finalize_spec");
      begin
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "system__file_io__finalize_body");
      begin
         E185 := E185 - 1;
         F8;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (Ada, s_stalib_adafinal, "system__standard_library__adafinal");

      procedure Runtime_Finalize;
      pragma Import (C, Runtime_Finalize, "__gnat_runtime_finalize");

   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      Runtime_Finalize;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;
   pragma Favor_Top_Level (No_Param_Proc);

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Bind_Env_Addr : System.Address;
      pragma Import (C, Bind_Env_Addr, "__gl_bind_env_addr");

      procedure Runtime_Initialize (Install_Handler : Integer);
      pragma Import (C, Runtime_Initialize, "__gnat_runtime_initialize");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, True, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (True, False, False, False, True, True, False, False, 
           True, False, False, True, True, True, True, False, 
           False, False, False, False, True, True, False, True, 
           True, False, True, True, True, True, False, False, 
           False, False, False, True, False, True, True, False, 
           True, True, True, True, False, True, False, True, 
           True, False, True, True, False, True, True, False, 
           False, False, False, True, True, True, True, True, 
           False, False, True, False, True, True, True, False, 
           True, True, False, True, True, True, True, False, 
           True, False, False, False, False, True, True, True, 
           True, False, True, False),
         Count => (0, 0, 0, 2, 2, 1, 2, 0, 1, 0),
         Unknown => (False, False, False, False, False, False, True, False, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;

      Runtime_Initialize (1);

      Finalize_Library_Objects := finalize_library'access;

      Ada.Exceptions'Elab_Spec;
      System.Soft_Links'Elab_Spec;
      System.Exception_Table'Elab_Body;
      E027 := E027 + 1;
      Ada.Containers'Elab_Spec;
      E042 := E042 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E072 := E072 + 1;
      Ada.Strings'Elab_Spec;
      E057 := E057 + 1;
      Ada.Strings.Maps'Elab_Spec;
      E059 := E059 + 1;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E063 := E063 + 1;
      Interfaces.C'Elab_Spec;
      E047 := E047 + 1;
      System.Exceptions'Elab_Spec;
      E029 := E029 + 1;
      System.Object_Reader'Elab_Spec;
      E083 := E083 + 1;
      System.Dwarf_Lines'Elab_Spec;
      E052 := E052 + 1;
      System.Os_Lib'Elab_Body;
      E077 := E077 + 1;
      System.Soft_Links.Initialize'Elab_Body;
      E023 := E023 + 1;
      E015 := E015 + 1;
      System.Traceback.Symbolic'Elab_Body;
      E041 := E041 + 1;
      E010 := E010 + 1;
      Ada.Numerics'Elab_Spec;
      E119 := E119 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Tags'Elab_Body;
      E110 := E110 + 1;
      Ada.Streams'Elab_Spec;
      E108 := E108 + 1;
      System.File_Control_Block'Elab_Spec;
      E186 := E186 + 1;
      System.Finalization_Root'Elab_Spec;
      E116 := E116 + 1;
      Ada.Finalization'Elab_Spec;
      E106 := E106 + 1;
      System.File_Io'Elab_Body;
      E185 := E185 + 1;
      System.Storage_Pools'Elab_Spec;
      E194 := E194 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Finalization_Masters'Elab_Body;
      E190 := E190 + 1;
      System.Storage_Pools.Subpools'Elab_Spec;
      E200 := E200 + 1;
      System.Task_Info'Elab_Spec;
      E142 := E142 + 1;
      System.Task_Primitives.Operations'Elab_Body;
      E136 := E136 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E008 := E008 + 1;
      Ada.Calendar.Delays'Elab_Body;
      E006 := E006 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E178 := E178 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E181 := E181 + 1;
      System.Pool_Global'Elab_Spec;
      E196 := E196 + 1;
      System.Random_Seed'Elab_Body;
      E214 := E214 + 1;
      System.Tasking.Initialization'Elab_Body;
      E164 := E164 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E152 := E152 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E168 := E168 + 1;
      System.Tasking.Queuing'Elab_Body;
      E170 := E170 + 1;
      System.Tasking.Stages'Elab_Body;
      E176 := E176 + 1;
      Message_Graph'Elab_Spec;
      E188 := E188 + 1;
      Graph_Tasks'Elab_Spec;
      Graph_Tasks'Elab_Body;
      E121 := E121 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      if gnat_argc = 0 then
         gnat_argc := argc;
         gnat_argv := argv;
      end if;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/erthax/Desktop/Programowanie/Programowanie_wsp????bie??ne/lista1/Ada_zad1/obj/message_graph.o
   --   /home/erthax/Desktop/Programowanie/Programowanie_wsp????bie??ne/lista1/Ada_zad1/obj/graph_tasks.o
   --   /home/erthax/Desktop/Programowanie/Programowanie_wsp????bie??ne/lista1/Ada_zad1/obj/main.o
   --   -L/home/erthax/Desktop/Programowanie/Programowanie_wsp????bie??ne/lista1/Ada_zad1/obj/
   --   -L/home/erthax/Desktop/Programowanie/Programowanie_wsp????bie??ne/lista1/Ada_zad1/obj/
   --   -L/home/erthax/opt/GNAT/2020/lib/gcc/x86_64-pc-linux-gnu/9.3.1/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
   --   -lrt
   --   -lpthread
   --   -ldl
--  END Object file/option list   

end ada_main;
