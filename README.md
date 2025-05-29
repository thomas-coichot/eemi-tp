# Sujet de Test Flutter – Gestion de Produits

## 🎯 Objectif

Développer une application Flutter permettant de **consulter, créer et modifier des produits** à l’aide d’une API REST.

---

## Fonctionnalités attendues

### 1. Liste des produits

- Récupérer la liste des produits via le endpoint : ```GET https://eemi-39b84a24258a.herokuapp.com/products```
- Afficher chaque produit dans une **liste scrollable**, avec :
    - **Nom** du produit
    - **Description courte**
    - **Image**

---

### 2. Création d’un produit

- Ajouter un bouton **“Ajouter un produit”** sur la page de liste.
- Rediriger vers une page avec un **formulaire** contenant les champs suivants :
    - `name` : Nom du produit
    - `short_description` : Description courte
    - `long_description` : Description longue
    - `price` : Prix
    - `image` : URL de l’image
- Validation des champs du formulaire.
- Envoyer les données via une requête ```POST https://eemi-39b84a24258a.herokuapp.com/products```

---

### 3. Édition d’un produit

- Depuis la page de détails, ajouter un bouton **“Modifier”**.
- Rediriger vers un **formulaire pré-rempli** avec les informations du produit.
- Soumettre les modifications via une requête ```PUT https://eemi-39b84a24258a.herokuapp.com/products/{uuid}```
- Rediriger vers la page de liste des produits.

---

### 3. Suppression d’un produit

- Depuis la page de détails, ajouter un bouton **“Supprimer”**.
- Soumettre la suppression via une requête ```DELETE https://eemi-39b84a24258a.herokuapp.com/products/{uuid}```
- Rediriger vers la page de liste des produits.

### 4. Détail d’un produit

- Au clic sur un produit, ouvrir une modalBottomSheet affichant les détails du produit.
- Récupérer les données du produit via : ```GET https://eemi-39b84a24258a.herokuapp.com/products/{uuid}```
- Afficher tous les champs, incluant les descriptions et le prix.

### 5. Bonus - Rechercher un produit

- Créer une barre de recherche sur la page de liste.

---

## 💡 Contraintes techniques

- Utiliser le package [`http`](https://pub.dev/packages/http) pour les appels réseau.
- Utiliser le package [`go_router`](https://pub.dev/packages/go_router) pour gérer ou la **navigation**.

## ✅ Bonus (facultatif)

- Affichage de messages de succès/erreur après une requête.
- Gestion d’un état de chargement (shimmer, progress-indicator).
- Scroll infini pour charger plus de produits.

---


