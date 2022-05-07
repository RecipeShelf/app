CREATE MIGRATION m1eyexebewoylrcjfq5p4tsoadt2pyh4m26pivym2a3lkcvxa75opa
    ONTO m17tpefsqlwxspbq2gy4p6mjw2rxgs2k4ko33u2t5f2bg5d2lu2mua
{
  ALTER TYPE default::Ingredient {
      CREATE PROPERTY external_id -> std::str;
  };
  ALTER TYPE default::Recipe {
      CREATE PROPERTY external_id -> std::str;
  };
  ALTER TYPE default::User {
      CREATE PROPERTY external_id -> std::str;
  };
};
