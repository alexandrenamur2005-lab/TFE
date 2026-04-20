
# On importe les bibliothèques nécessaires
require 'sinatra'
require 'sqlite3'


# On indique à Sinatra où sont les fichiers
set :views, File.join(__dir__, 'page')
set :public_folder, File.join(__dir__, 'css')

# Connexion à la base de données SQLite
DB = SQLite3::Database.new "database.db"

# Création de la table si elle n'existe pas
DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS commandes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT,
    prenom TEXT,
    classe TEXT,
    sandwich TEXT,
    crudites TEXT
  );
SQL


# PAGE MENU (ACCUEIL)

get '/' do
  erb :index
end


# PAGE ELEVE

get '/eleve' do
  erb :eleve
end

# Quand l'élève envoie le formulaire
post '/eleve' do
  DB.execute("INSERT INTO commandes (nom, prenom, classe, sandwich, crudites)
              VALUES (?, ?, ?, ?, ?)",
              params[:nom], params[:prenom], params[:classe],
              params[:sandwich], params[:crudites])

  "Commande enregistrée !"
end


# PAGE PROFESSEUR

get '/professeur' do
  erb :professeur
end

post '/professeur' do
  DB.execute("INSERT INTO commandes (prenom, sandwich, crudites)
              VALUES (?, ?, ?)",
              params[:prenom], params[:sandwich], params[:crudites])

  "Commande professeur enregistrée !"
end


# PAGE ADMIN (LOGIN)

post '/admin_login' do
  if params[:password] == "ipesmdp"
    redirect '/admin'
  else
    "Mot de passe incorrect"
  end
end


# PAGE ADMIN

get '/admin' do
  @commandes = DB.execute("SELECT * FROM commandes")
  erb :admin
end


# SUPPRESSION

post '/delete/:id' do
  DB.execute("DELETE FROM commandes WHERE id = ?", params[:id])
  redirect '/admin'
end