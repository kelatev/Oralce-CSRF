PL/SQL Developer Test script 3.0
18
DECLARE
  l_user_id CONSTANT NUMBER := 1;
  l_secret  CONSTANT VARCHAR2(200) := dbms_random.string('p', 100);

  l_token VARCHAR2(1000);
BEGIN
  dbms_output.put_line('***INPUT***');
  dbms_output.put_line('secret: ' || l_secret);
  l_token := sa_csrf.make_token(p_user_id => l_user_id, p_secret => l_secret);
  dbms_output.put_line('token: ' || l_token);

  dbms_output.put_line('***CHECK***');
  IF sa_csrf.is_valid(p_token => l_token, p_user_id => l_user_id, p_secret => l_secret) THEN
    dbms_output.put_line('valid');
  ELSE
    dbms_output.put_line('valid');
  END IF;
END;
0
0
