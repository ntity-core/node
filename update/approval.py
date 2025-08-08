#!/usr/bin/env python3

import os
import json
import requests
from datetime import datetime, timezone
import logging

# Configuration
LOG_FILE = "./nethermind_proposals.log"
PROCESSED_FILE = "./processed_proposals.json"
APPROUVAL_API_URL = "https://api.ntity.io/v3/misc/approval"
DOCKER_URL = "http://localhost:8545"

# Configuration du logging
logging.basicConfig(
    filename=LOG_FILE, 
    level=logging.INFO, 
    format='%(asctime)s - %(message)s', 
    datefmt='%Y-%m-%d %H:%M:%S'
)

def ensure_processed_file_exists():
    """Crée le fichier de suivi s'il n'existe pas"""
    if not os.path.exists(PROCESSED_FILE):
        with open(PROCESSED_FILE, 'w') as f:
            json.dump({"processed_proposals": []}, f)
        logging.info("Fichier de suivi des proposals initialisé")

def get_proposals():
    """Récupère les proposals via l'API"""
    try:
        headers = {
            "Content-Type": "application/json"
        }
        
        response = requests.get(APPROUVAL_API_URL, headers=headers)
        response.raise_for_status()
        
        data = response.json()

        print(data['data'])
        
        if not data.get('success'):
            logging.error(f"Erreur API: {data.get('msg', 'Erreur inconnue')}")
            return []
        
        # Transformer les données en liste de dictionnaires
        proposals = [
            {"wallet": wallet, "status": status} 
            for entry in data['data'] 
            for wallet, status in entry.items()
        ]


        print(proposals)
        
        return proposals
    
    except Exception as e:
        logging.error(f"Erreur lors de la récupération des proposals: {e}")
        return []

def is_proposal_processed(wallet):
    """Vérifie si un proposal a déjà été traité"""
    try:
        with open(PROCESSED_FILE, 'r') as f:
            processed_data = json.load(f)
            return any(p['wallet'] == wallet for p in processed_data['processed_proposals'])
    except Exception as e:
        logging.error(f"Erreur lors de la vérification des proposals traités: {e}")
        return False

def mark_proposal_as_processed(wallet, status):
    """Marque un proposal comme traité"""
    try:
        with open(PROCESSED_FILE, 'r+') as f:
            processed_data = json.load(f)
            processed_data['processed_proposals'].append({
                'wallet': wallet,
                'status': status,
                'timestamp': datetime.now(timezone.utc).isoformat()
            })
            f.seek(0)
            json.dump(processed_data, f, indent=2)
            f.truncate()
    except Exception as e:
        logging.error(f"Erreur lors de l'enregistrement du proposal traité: {e}")

def process_and_add_proposals():
    """Traite et ajoute les nouveaux proposals"""
    proposals = get_proposals()
    
    new_proposals = 0
    already_processed = 0
    
    for proposal in proposals:
        wallet = proposal.get('wallet', '')
        status = proposal.get('status', '')
        
        if not wallet:
            logging.warning(f"Proposal incomplet: {proposal}")
            continue
        
        if is_proposal_processed(wallet):
            logging.info(f"Proposal déjà traité, ignoré: {wallet}")
            already_processed += 1
            continue
        
        try:
            print([wallet, status])
            payload = {
                "jsonrpc": "2.0",
                "method": "clique_propose",
                "params": [wallet, status],
                "id": 1
            }

            response = requests.post(DOCKER_URL, json=payload)
            data = response.json()

            print(data)

            if 'result' in response and response['result'] is not None:
                logging.info(f"Proposal ajouté avec succès: {wallet}")
                mark_proposal_as_processed(wallet, status)
                new_proposals += 1
                
            else:
                logging.error(f"Erreur lors de l'ajout du proposal: {wallet}")
                    
        except Exception as e:
            logging.error(f"Exception lors du traitement du proposal {wallet}: {e}")
    
    logging.info(f"Récapitulatif: {new_proposals} nouveaux proposals traités, {already_processed} déjà traités")

def main():
    """Fonction principale du script"""
    logging.info("Script de traitement des proposals démarré")
    ensure_processed_file_exists()
    process_and_add_proposals()
    logging.info("Script terminé")

if __name__ == "__main__":
    main()