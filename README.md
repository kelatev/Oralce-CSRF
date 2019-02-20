# Oralce-CSRF

`DECLARE
  l_user_id CONSTANT NUMBER := 1;
  l_secret  CONSTANT VARCHAR2(200) := dbms_random.string('p', 100);

  l_token VARCHAR2(1000);
BEGIN
  l_token := sa_csrf.make_token(p_user_id => l_user_id, p_secret => l_secret);

  IF sa_csrf.is_valid(p_token => l_token, p_user_id => l_user_id, p_secret => l_secret) THEN
    dbms_output.put_line('valid');
  END IF;
END;`
