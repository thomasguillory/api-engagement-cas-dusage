# MVP

## Implémentation

TODO

## Question Bonus

> Donne une raison pour laquelle dans le lien de la candidature, il est utile de préciser l’identifiant de la

On parle ici de l'appel suivant : `GET - /r/apply?view={token}&mission={missionId}&publisher={publisherId}`

Prenons pour exemple le scénario suivant :

- L'utilisateur clique sur un lien de redirection qui le fait arriver sur une annonce pour une mission A d'un partenaire annonceur - un token est généré et stocké dans les cookies sur ce site
- Tout en restant sur le même site, l'utilisateur change d'annonce et visite une annonce pour une mission B qui se trouve également provenir de l'API Engagement
- L'utilisateur postule et le lien de tracking est appelé

==> Le token seul ne permet pas de présumer de quelle mission est concernée. Le missionId est donc nécessaire.
