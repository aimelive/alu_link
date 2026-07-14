/// LaunchPad ALU copy, in English and French.
/// Screens call context.read<LanguageProvider>().t('key').
class AppStrings {
  static const Map<String, Map<String, String>> _values = {
    // Auth
    'welcome': {'en': 'LaunchPad ALU', 'fr': 'LaunchPad ALU'},
    'tagline': {
      'en': 'Every venture needs a crew.',
      'fr': 'Chaque venture a besoin d\'un equipage.'
    },
    'email': {'en': 'Email', 'fr': 'E-mail'},
    'password': {'en': 'Password', 'fr': 'Mot de passe'},
    'login': {'en': 'Sign in', 'fr': 'Se connecter'},
    'wrong_details': {
      'en': 'Those details didn\'t match. Check them or create an account.',
      'fr': 'Identifiants incorrects. Verifiez-les ou creez un compte.'
    },
    'no_account': {
      'en': 'New to the pad? Create an account',
      'fr': 'Nouveau ici ? Creer un compte'
    },
    'join_app': {'en': 'Join LaunchPad', 'fr': 'Rejoindre LaunchPad'},
    'full_name': {'en': 'Full name', 'fr': 'Nom complet'},
    'name_required': {'en': 'Name is required', 'fr': 'Le nom est requis'},
    'valid_email': {
      'en': 'Enter a valid email (e.g. name@alustudent.com)',
      'fr': 'Entrez un e-mail valide (ex. nom@alustudent.com)'
    },
    'password_rule': {
      'en': 'At least 6 characters, 1 capital letter and 1 number',
      'fr': 'Au moins 6 caracteres, 1 majuscule et 1 chiffre'
    },
    'i_am_a': {'en': 'I\'m joining as', 'fr': 'Je rejoins en tant que'},
    'student_role': {'en': 'Student (crew)', 'fr': 'Etudiant(e) (equipage)'},
    'organization': {
      'en': 'ALU venture / department',
      'fr': 'Venture / departement ALU'
    },
    'signup': {'en': 'Create account', 'fr': 'Creer le compte'},

    // Student shell
    'missions': {'en': 'Missions', 'fr': 'Missions'},
    'missions_hero': {
      'en': 'Find your next mission',
      'fr': 'Trouvez votre prochaine mission'
    },
    'journey': {'en': 'Journey', 'fr': 'Parcours'},
    'crew_card': {'en': 'Crew card', 'fr': 'Carte equipage'},
    'search_hint': {
      'en': 'Search missions, ventures or skills...',
      'fr': 'Rechercher missions, ventures ou competences...'
    },
    'all': {'en': 'All', 'fr': 'Tous'},
    'category': {'en': 'Department', 'fr': 'Departement'},
    'no_results': {
      'en': 'No missions on the board match your search.',
      'fr': 'Aucune mission ne correspond a votre recherche.'
    },
    'open_missions': {'en': 'missions open now', 'fr': 'missions ouvertes'},
    'readiness': {'en': 'ready', 'fr': 'pret'},

    // Mission detail
    'mission_brief': {'en': 'Mission brief', 'fr': 'Brief de mission'},
    'about_role': {'en': 'The brief', 'fr': 'Le brief'},
    'required_skills': {
      'en': 'Skills this mission needs',
      'fr': 'Competences requises'
    },
    'your_readiness': {'en': 'Your readiness', 'fr': 'Votre preparation'},
    'readiness_hint': {
      'en': 'Based on how your crew card skills cover this brief.',
      'fr': 'Base sur la couverture de vos competences.'
    },
    'apply_now': {'en': 'Request to join', 'fr': 'Demander a rejoindre'},
    'application_sent': {
      'en': 'Request sent. Track it on your Journey tab.',
      'fr': 'Demande envoyee. Suivez-la dans Parcours.'
    },

    // Journey (applications)
    'my_applications': {'en': 'My journey', 'fr': 'Mon parcours'},
    'no_applications': {
      'en': 'No missions requested yet. Your journey starts on the board.',
      'fr': 'Aucune demande. Votre parcours commence sur le tableau.'
    },
    'applied': {'en': 'Requested', 'fr': 'Demande'},
    'shortlisted': {'en': 'Shortlisted', 'fr': 'Preselection'},
    'interview': {'en': 'Interview', 'fr': 'Entretien'},
    'accepted': {'en': 'Onboard', 'fr': 'A bord'},
    'rejected': {'en': 'Not this time', 'fr': 'Pas cette fois'},
    'status': {'en': 'Stage', 'fr': 'Etape'},

    // Crew card (student profile)
    'my_skills': {'en': 'Skill deck', 'fr': 'Mes competences'},
    'skills_hint': {
      'en': 'Skills power your readiness score on every mission.',
      'fr': 'Vos competences alimentent votre score de preparation.'
    },
    'add_skill_hint': {
      'en': 'Add a skill (e.g. Figma, Flutter, Canva)',
      'fr': 'Ajouter une competence (ex. Figma, Flutter)'
    },
    'add': {'en': 'Add', 'fr': 'Ajouter'},
    'no_skills': {
      'en': 'Your deck is empty. Add skills to start matching.',
      'fr': 'Aucune competence. Ajoutez-en pour matcher.'
    },
    'logout': {'en': 'Sign out', 'fr': 'Deconnexion'},

    // Venture (startup) shell
    'my_opportunities': {'en': 'Command deck', 'fr': 'Poste de commande'},
    'post_opportunity': {'en': 'Launch a mission', 'fr': 'Lancer une mission'},
    'my_profile': {'en': 'Venture', 'fr': 'Venture'},
    'my_roles': {'en': 'Deck', 'fr': 'Missions'},
    'post': {'en': 'Launch', 'fr': 'Lancer'},
    'profile': {'en': 'Venture', 'fr': 'Venture'},
    'opp_title': {'en': 'Mission title', 'fr': 'Titre de la mission'},
    'title_required': {'en': 'Title is required', 'fr': 'Le titre est requis'},
    'opp_description': {'en': 'Mission brief', 'fr': 'Brief de mission'},
    'desc_required': {
      'en': 'A brief is required',
      'fr': 'Le brief est requis'
    },
    'skills_csv': {
      'en': 'Skills needed (comma separated)',
      'fr': 'Competences (separees par virgules)'
    },
    'posted': {
      'en': 'Mission is live on the board.',
      'fr': 'Mission publiee sur le tableau.'
    },
    'no_posts': {
      'en': 'No missions launched yet. Your first crew is waiting.',
      'fr': 'Aucune mission lancee. Votre equipage vous attend.'
    },
    'view_applicants': {'en': 'Review crew', 'fr': 'Voir l\'equipage'},
    'close_role': {'en': 'Close', 'fr': 'Fermer'},
    'delete_role': {'en': 'Delete', 'fr': 'Supprimer'},
    'closed': {'en': 'Closed', 'fr': 'Fermee'},
    'open': {'en': 'Open', 'fr': 'Ouverte'},

    // Applicant review
    'no_applicants': {
      'en': 'No crew requests yet for this mission.',
      'fr': 'Aucune demande pour cette mission.'
    },
    'shortlist': {'en': 'Shortlist', 'fr': 'Preselectionner'},
    'accept': {'en': 'Accept', 'fr': 'Accepter'},
    'reject': {'en': 'Decline', 'fr': 'Refuser'},
    'match': {'en': 'ready', 'fr': 'pret'},

    // Venture profile
    'about_org': {'en': 'About this venture', 'fr': 'A propos'},
    'about_org_hint': {
      'en': 'Students see this before requesting to join your missions.',
      'fr': 'Les etudiants voient ceci avant de postuler.'
    },
    'save_profile': {'en': 'Save venture', 'fr': 'Enregistrer'},
    'profile_saved': {'en': 'Venture saved.', 'fr': 'Venture enregistree.'},
    'verified': {'en': 'Cleared for launch', 'fr': 'Verifiee'},
    'not_verified': {'en': 'Awaiting clearance', 'fr': 'En attente'},

    // Admin
    'admin_verify': {'en': 'Mission control', 'fr': 'Controle de mission'},
    'admin_sub': {
      'en': 'Clear ALU ventures so their missions can go live.',
      'fr': 'Verifiez les ventures ALU pour publier leurs missions.'
    },
    'no_orgs': {
      'en': 'No ventures registered yet.',
      'fr': 'Aucune venture enregistree.'
    },
    'verify': {'en': 'Clear', 'fr': 'Verifier'},
  };

  static String get(String key, String lang) {
    return _values[key]?[lang] ?? _values[key]?['en'] ?? key;
  }
}
