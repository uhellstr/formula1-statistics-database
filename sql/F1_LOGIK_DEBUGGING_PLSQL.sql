-- Debugging PL/SQL code with SQL*Developer VS Code

-- Run as sys
grant db_developer_role to f1_logik;
grant debug connect session to f1_logik;
grant debug connect any to f1_logik;
grant debug any procedure to f1_logik;

begin
   dbms_network_acl_admin.append_host_ace(
      host => '*',
      ace  => sys.xs$ace_type(
                 privilege_list => sys.xs$name_list('jdwp') ,
                 principal_name => 'f1_logik',
                 principal_type => sys.xs_acl.ptype_db
              )
   );
end;
/