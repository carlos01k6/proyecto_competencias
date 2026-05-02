from flask import Blueprint, request, jsonify
from flask_cors import cross_origin
from ..supabase_client import get_supabase

registro_batch_bp = Blueprint("registro_batch", __name__, url_prefix="/api/registro")
supabase = get_supabase()

@registro_batch_bp.route("/estudiantes-batch", methods=["POST"])
@cross_origin()
def registrar_estudiantes_batch():
    """Registra múltiples estudiantes en Supabase Auth"""
    try:
        estudiantes = [
            {"nombre": "Gabriel Elias Alcala Aquino", "email": "gabriel.alcala@edu.com"},
            {"nombre": "Winniviel Bello", "email": "winniviel.bello@edu.com"},
            {"nombre": "Deuli de la Cruz Ramirez", "email": "deuli.cruz@edu.com"},
            {"nombre": "Katherine Marie Cuesta Marte", "email": "katherine.cuesta@edu.com"},
            {"nombre": "Elyin Emmanuel Diaz Adamez", "email": "elyin.diaz@edu.com"},
            {"nombre": "Juan Armando Felix Norberto", "email": "juan.felix@edu.com"},
            {"nombre": "Justin Ezequiel", "email": "justin.ezequiel@edu.com"},
            {"nombre": "Maikel Yael", "email": "maikel.yael@edu.com"},
            {"nombre": "Carlos Miguel Lima Camacho", "email": "carlos.lima@edu.com"},
            {"nombre": "Yeuri Lorenzo Diaz", "email": "yeuri.lorenzo@edu.com"},
            {"nombre": "Nashly Adriana Magallanes Feliz", "email": "nashly.magallanes@edu.com"},
            {"nombre": "Angelo Alexander Mancebo", "email": "angelo.mancebo@edu.com"},
            {"nombre": "Enrique Ogando", "email": "enrique.ogando@edu.com"},
            {"nombre": "Jose Emmanuel Pichardo", "email": "jose.pichardo@edu.com"},
            {"nombre": "Ernesto Luis Pichardo", "email": "ernesto.pichardo@edu.com"},
            {"nombre": "Dustin Alexander Polanco Muños", "email": "dustin.polanco@edu.com"},
            {"nombre": "Michael Ramirez Feliz", "email": "michael.ramirez@edu.com"},
            {"nombre": "Eliezer de Jesus", "email": "eliezer.jesus@edu.com"},
            {"nombre": "Jeremy Manuel", "email": "jeremy.manuel@edu.com"},
            {"nombre": "Ashly Pamela Reding Hernandez", "email": "ashly.reding@edu.com"},
            {"nombre": "Gianni Subervi Alcantara", "email": "gianni.subervi@edu.com"}
        ]
        
        registrados = []
        errores = []
        
        for est in estudiantes:
            try:
                response = supabase.auth.sign_up({
                    "email": est["email"],
                    "password": "password",
                    "options": {
                        "data": {
                            "name": est["nombre"]
                        }
                    }
                })
                registrados.append(est["email"])
            except Exception as e:
                errores.append({"email": est["email"], "error": str(e)})
        
        return jsonify({
            "registrados": len(registrados),
            "errores": len(errores),
            "detalles_errores": errores
        }), 201
    except Exception as e:
        print(f"ERROR BATCH: {str(e)}")
        return jsonify({"error": str(e)}), 500



