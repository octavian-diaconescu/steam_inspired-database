import cx_Oracle
import re
import tkinter as tk
from tkinter import ttk, messagebox


def conexiune(user, parola, host, port, sid):
    try:
        dsn = cx_Oracle.makedsn(host, port, sid=sid)
        connection = cx_Oracle.connect(user, parola, dsn)
        print("Conexiune realizata cu succes!")
        return connection
    except cx_Oracle.DatabaseError as e:
        print("Eroare de conectare:", e)
        raise


def listare_continut(conexiune, nume_tabel, coloana_sortare=None, ordine="ASC"):
    try:
        cursor = conexiune.cursor()
        interogare = f"SELECT * FROM {nume_tabel}"
        if coloana_sortare:
            interogare += f" ORDER BY {coloana_sortare} {ordine}"
        cursor.execute(interogare)
        linii = cursor.fetchall()
        coloane = [col[0] for col in cursor.description]
        cursor.close()
        return linii, coloane
    except cx_Oracle.DatabaseError as e:
        print("Eroare la afisarea continutului: ", e)
        raise


def editare_intrare(conexiune, nume_tabel, pk_conditions, actualizare):
    try:
        cursor = conexiune.cursor()
        #formatul datei: YYYY-MM-DD
        format_data = re.compile(r"^\d{4}-\d{2}-\d{2}$")
        clauza_set = []
        param = {} 
        for key, value in actualizare.items():
            if isinstance(value, str) and format_data.match(value):
                clauza_set.append(f"{key} = TO_DATE(:{key}, 'YYYY-MM-DD')")
                param[key] = value
            else:
                clauza_set.append(f"{key} = :{key}")
                param[key] = value

        set_clauza = ", ".join(clauza_set)

        clauza_where = []
        for col, val in pk_conditions.items():
            clauza_where.append(f"{col} = :{col}")
            param[col] = val

        where_clause = " AND ".join(clauza_where)

        query = f"UPDATE {nume_tabel} SET {set_clauza} WHERE {where_clause}"

        cursor.execute(query, param)
        conexiune.commit()
        print("Intrare actualizata cu succes.")
        cursor.close()
    except cx_Oracle.DatabaseError as e:
        print("Eroare la actualizare:", e)
        raise


def sterge_intrare(conexiune, nume_tabel, conditii_pk):
    try:
        cursor = conexiune.cursor()
        conditii = " AND ".join(f"{col} = :{col}" for col in conditii_pk.keys())
        interogare = f"DELETE FROM {nume_tabel} WHERE {conditii}"
        cursor.execute(interogare, conditii_pk)
        conexiune.commit()
        print("Intrare stearsa cu succes.")
        cursor.close()
    except cx_Oracle.DatabaseError as e:
        print("Eroare la stergere:", e)
        raise

def main():
    UTILIZATOR = "user_bd"
    PAROLA = "bazededate"
    HOST = "localhost"
    PORT = 1521
    SID = "xe"
    connection = conexiune(UTILIZATOR, PAROLA, HOST, PORT, SID)

    def reimprospatare():
        try:
            tabel = nume_tabel.get()
            coloana_de_sorta = sortare.get() or None
            ordine = ordine_sortare.get()
            linii, coloane = listare_continut(
                connection, tabel, coloana_de_sorta, ordine
            )

            for item in tree.get_children():
                tree.delete(item)

            tree["columns"] = coloane
            tree["show"] = "headings"

            for col in coloane:
                tree.heading(col, text=col)
                tree.column(col, width=max(100, len(col) * 10))

            for row in linii:
                tree.insert("", "end", values=row)
        except Exception as e:
            messagebox.showerror("Eroare:", str(e))

    def actualizeaza_intrare():
        try:
            tabel = nume_tabel.get()
            coloane_pk = pk_column_entry.get().split(",")
            valori_pk = pk_value_entry.get().split(",")
            conditii = {col.strip(): val.strip() for col, val in zip(coloane_pk, valori_pk)}
            nume_coloana = update_column_entry.get()
            valoare_noua = update_value_entry.get()
            update = {nume_coloana: valoare_noua}
            editare_intrare(
            connection,
            tabel,
            conditii,
            update,
            )
            reimprospatare()
            messagebox.showinfo("Succes", "Intrare actualizata cu succes")
        except Exception as e:
            messagebox.showerror("Eroare:", str(e))

    def sterge_intrare_selectata():
        try:
            item_selectat = tree.selection()[0]
            valori = tree.item(item_selectat, "values")

            tabel = nume_tabel.get()
            
            coloane_pk = pk_column_entry.get().split(",")
            conditii_pk = {col.strip(): valori[i] for i, col in enumerate(coloane_pk)}

            sterge_intrare(connection, tabel, conditii_pk)
            reimprospatare()
            messagebox.showinfo("Succes", "Intrare stearsa cu succes")
        except Exception as e:
            messagebox.showerror("Eroare:", str(e))

    def cerinta_c():
        interogare = """
        select id_joc, nume, pret, denumire_misiune, dificultate, nume_producator, nume_categorie, apreciere
        from misiune right join joc using(id_joc) full join producator using(nume_producator) join categorie using (nume_categorie)
        where dificultate in('usor', 'foarte usor') and pret < 30
        """
        messagebox.showinfo(
            "Cerinta c)", f"Interogarea care urmeaza sa fie executata:\n{interogare}"
        )
        try:
            cursor = connection.cursor()
            cursor.execute(interogare)
            linii = cursor.fetchall()
            coloane = [col[0] for col in cursor.description]
            cursor.close()

            for item in tree.get_children():
                tree.delete(item)

            tree["columns"] = coloane
            tree["show"] = "headings"

            for col in coloane:
                tree.heading(col, text=col)
                tree.column(col, width=max(100, len(col) * 10))

            for row in linii:
                tree.insert("", "end", values=row)

        except cx_Oracle.DatabaseError as e:
            messagebox.showerror("Eroare", f"Eroare la executie: {e}")

    def cerinta_d():
        interogare = """
        SELECT username, ROUND(avg(pret_cumparare),1) AS "PRET MEDIU PLATIT", count(id_joc) AS "NUMAR JOCURI CUMPARATE"
        FROM cumpara
        GROUP BY username
        HAVING count(id_joc) > 2 AND avg(pret_cumparare) > 15
        """
        messagebox.showinfo(
            "Cerinta d)",
            f"Interogarea care urmeaza sa fie executata:\n{interogare}",
        )
        try:
            cursor = connection.cursor()
            cursor.execute(interogare)
            linii = cursor.fetchall()
            coloane = [col[0] for col in cursor.description]
            cursor.close()

            for item in tree.get_children():
                tree.delete(item)

            tree["columns"] = coloane
            tree["show"] = "headings"

            for col in coloane:
                tree.heading(col, text=col)
                tree.column(col, width=max(100, len(col) * 10))

            for row in linii:
                tree.insert("", "end", values=row)

        except cx_Oracle.DatabaseError as e:
            messagebox.showerror("Eroare", f"Eroare la executie: {e}")
            
    def vizualizare_compusa():
        interogare = """
        CREATE OR REPLACE VIEW vizualizare_compusa AS
        SELECT nume_producator, id_joc, nume, pret, varsta_minima, nume_categorie
        FROM PRODUCATOR join JOC using(nume_producator)
        """
        messagebox.showinfo("Vizualizare compusa", f"Interogarea care urmeaza sa fie executata:\n{interogare}")
        try:
            cursor = connection.cursor()
            cursor.execute(interogare)
            cursor.execute("SELECT * FROM vizualizare_compusa")
            linii = cursor.fetchall()
            coloane = [col[0] for col in cursor.description]
            cursor.close()

            for item in tree.get_children():
                tree.delete(item)

            tree["columns"] = coloane
            tree["show"] = "headings"

            for col in coloane:
                tree.heading(col, text=col)
                tree.column(col, width=max(100, len(col) * 10))

            for row in linii:
                row = ["(null)" if val is None else val for val in row]
                tree.insert("", "end", values=row)

        except cx_Oracle.DatabaseError as e:
            messagebox.showerror("Eroare", f"Eroare la executie: {e}")

    def vizualizare_complexa():
        interogare = """
        CREATE OR REPLACE VIEW vizualizare_complexa AS
        SELECT username, max(pret_cumparare) AS "PRETUL CELUI MAI SCUMP JOC DIN LIBRARIE", sum(pret_cumparare) AS "VALOARE LIBRARIE",
        (SELECT nume_categorie 
            FROM (
            SELECT nume_categorie, count(id_joc) 
            FROM cumpara JOIN joc USING (id_joc) JOIN categorie USING (nume_categorie)
            WHERE username = c.username
            GROUP BY nume_categorie
            ORDER BY count(id_joc) DESC)
            WHERE ROWNUM = 1) AS "CATEGORIA FAVORITA"
        FROM cumpara c
        GROUP BY username
        """
        messagebox.showinfo("Vizualizare complexa", f"Interogarea care urmeaza sa fie executata:\n{interogare}")
        try:
            cursor = connection.cursor()
            cursor.execute(interogare)
            cursor.execute("SELECT * FROM vizualizare_complexa")
            linii = cursor.fetchall()
            coloane = [col[0] for col in cursor.description]
            cursor.close()

            for item in tree.get_children():
                tree.delete(item)

            tree["columns"] = coloane
            tree["show"] = "headings"

            for col in coloane:
                tree.heading(col, text=col)
                tree.column(col, width=max(100, len(col) * 10))

            for row in linii:
                tree.insert("", "end", values=row)

        except cx_Oracle.DatabaseError as e:
            messagebox.showerror("Eroare", f"Eroare la executie: {e}")

    root = tk.Tk()
    root.title("263 Diaconescu Octavian-Gabriel, Interfata BD")

    tk.Label(root, text="Numele tabelului:").grid(row=0, column=0)
    nume_tabel = tk.Entry(root)
    nume_tabel.grid(row=0, column=1)

    tk.Label(root, text="Coloana pentru sortare").grid(row=1, column=0)
    sortare = tk.Entry(root)
    sortare.grid(row=1, column=1)

    tk.Label(root, text="Ordinea sortarii").grid(row=2, column=0)
    ordine_sortare = ttk.Combobox(root, values=["ASC", "DESC"])
    ordine_sortare.set("ASC")
    ordine_sortare.grid(row=2, column=1)

    tk.Button(root, text="Reimprospateaza afisarea", command=reimprospatare).grid(
        row=3, column=0, columnspan=2
    )

    tk.Button(root, text="Cerinta c)", command=cerinta_c).grid(
        row=0, column=2, columnspan=2
    )

    tk.Button(root, text="Cerinta d)", command=cerinta_d).grid(
        row=0, column=4, columnspan=2
    )

    tk.Button(root, text="Vizualizare compusa", command=vizualizare_compusa).grid(
        row=0, column=6, columnspan=2
    )

    tk.Button(root, text="Vizualizare complexa", command=vizualizare_complexa).grid(
        row=0, column=8, columnspan=2
    )

    tree = ttk.Treeview(root)
    tree.grid(row=4, column=0, columnspan=10)

    tk.Label(root, text="Coloana PK").grid(row=5, column=0)
    pk_column_entry = tk.Entry(root)
    pk_column_entry.grid(row=5, column=1)

    tk.Label(root, text="Valorea PK").grid(row=6, column=0)
    pk_value_entry = tk.Entry(root)
    pk_value_entry.grid(row=6, column=1)

    tk.Label(root, text="Coloana pentru update").grid(row=7, column=0)
    update_column_entry = tk.Entry(root)
    update_column_entry.grid(row=7, column=1)

    tk.Label(root, text="Noua Valoare").grid(row=8, column=0)
    update_value_entry = tk.Entry(root)
    update_value_entry.grid(row=8, column=1)

    tk.Button(root, text="Update intrare", command=actualizeaza_intrare).grid(
        row=9, column=0, columnspan=2
    )

    tk.Button(
        root, text="Sterge intrarea selectata", command=sterge_intrare_selectata
    ).grid(row=10, column=0, columnspan=2)

    root.mainloop()


if __name__ == "__main__":
    main()