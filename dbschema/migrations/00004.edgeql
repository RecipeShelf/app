CREATE MIGRATION m173msyz5s3s4yy2b3theu6yygrxmmwjl5ywngtqavywjt4a5v7wua
    ONTO m164spjykf2acllkwsylirwkkll3lotue2w6dfwo7sbdrcw5bsktvq
{
  ALTER TYPE default::Recipe {
      ALTER LINK chef {
          RENAME TO owner;
      };
  };
  ALTER TYPE default::Recipe {
      ALTER PROPERTY approved {
          RENAME TO public;
      };
  };
};
