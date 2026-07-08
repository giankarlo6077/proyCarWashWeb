Imports System.Data
Imports com.somee.wspruebacarwash2

Partial Class jdInicioSesion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lblError.Text = ""
        End If
    End Sub

    Protected Sub btnIngresar_Click(ByVal sender As Object, ByVal e As EventArgs) Handles btnIngresar.Click

        lblError.Text = ""

        Dim usuario As String = txtUsuario.Text.Trim()
        Dim contrasena As String = txtPassword.Text.Trim()

        ' Validación básica de campos vacíos
        If usuario = "" Or contrasena = "" Then
            lblError.Text = "Por favor, ingrese usuario y contraseña."
            Exit Sub
        End If

        Try
            Dim objTrabajador As New WSv1

            ' 1. Verificamos si el usuario está activo/vigente
            Dim estaVigente As Boolean = objTrabajador.ValidarVigencia(usuario)

            If Not estaVigente Then
                lblError.Text = "El usuario no existe o se encuentra inactivo."
                Exit Sub
            End If

            ' 2. Validamos usuario y contraseña
            Dim nombreTrabajador As String = objTrabajador.Login(usuario, contrasena)

            If nombreTrabajador <> "" Then
                ' Login correcto -> Guardamos datos en sesión
                Session("Usuario") = usuario
                Session("NombreTrabajador") = nombreTrabajador

                ' Guardamos el rol del trabajador para el control de permisos del menú
                Dim dtRol As DataTable = objTrabajador.obtenerRolTrabajador(usuario)
                If dtRol IsNot Nothing AndAlso dtRol.Rows.Count > 0 Then
                    Session("IdRol") = dtRol.Rows(0)("idRol")
                    Session("NombreRol") = dtRol.Rows(0)("rol").ToString()
                Else
                    Session("IdRol") = Nothing
                    Session("NombreRol") = ""
                End If

                ' Redirigimos al menú principal
                Response.Redirect("FrmMenuPrincipal.aspx")
            Else
                lblError.Text = "Usuario o contraseña incorrectos."
            End If

        Catch ex As Exception
            lblError.Text = "Error al iniciar sesión: " & ex.Message
        End Try

    End Sub
End Class