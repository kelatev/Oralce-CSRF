CREATE OR REPLACE PACKAGE sa_csrf IS

  -- Author  : KELATEV
  -- Created : 05.02.2019 22:28:13

  FUNCTION make_token(p_user_id IN NUMBER,
                      p_secret  IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION make_token(p_salt      IN VARCHAR2,
                      p_user_data IN VARCHAR2,
                      p_secret    IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_salt(p_token IN VARCHAR2) RETURN VARCHAR2;
  FUNCTION is_valid(p_token   IN VARCHAR2,
                    p_user_id IN NUMBER,
                    p_secret  IN VARCHAR2) RETURN BOOLEAN;
  FUNCTION is_valid(p_token     IN VARCHAR2,
                    p_user_data IN VARCHAR2,
                    p_secret    IN VARCHAR2) RETURN BOOLEAN;

END sa_csrf;
/
CREATE OR REPLACE PACKAGE BODY sa_csrf IS

  --===============================================================================
  FUNCTION make_token(p_user_id IN NUMBER,
                      p_secret  IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN make_token(p_salt      => to_char(SYSDATE, 'yyyymmddhh24miss'),
                      p_user_data => TRIM(to_char(p_user_id)),
                      p_secret    => p_secret);
  END;
  --===============================================================================
  FUNCTION make_token(p_salt      IN VARCHAR2,
                      p_user_data IN VARCHAR2,
                      p_secret    IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN dbms_crypto.Hash(utl_raw.cast_to_raw(p_secret || p_user_data || p_salt), dbms_crypto.HMAC_SH256) || ':' || p_salt;
  END;
  --===============================================================================
  FUNCTION get_salt(p_token IN VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    RETURN substr(p_token, instr(p_token, ':') + 1);
  END;
  --===============================================================================
  FUNCTION is_valid(p_token   IN VARCHAR2,
                    p_user_id IN NUMBER,
                    p_secret  IN VARCHAR2) RETURN BOOLEAN IS
  BEGIN
    RETURN is_valid(p_token => p_token, p_user_data => TRIM(to_char(p_user_id)), p_secret => p_secret);
  END;
  --===============================================================================
  FUNCTION is_valid(p_token     IN VARCHAR2,
                    p_user_data IN VARCHAR2,
                    p_secret    IN VARCHAR2) RETURN BOOLEAN IS
    l_salt VARCHAR2(14);
  BEGIN
    l_salt := get_salt(p_token);
    RETURN dbms_crypto.Hash(utl_raw.cast_to_raw(p_secret || p_user_data || l_salt), dbms_crypto.HMAC_SH256) || ':' || l_salt = p_token;
  END;
  --===============================================================================
END sa_csrf;
/
