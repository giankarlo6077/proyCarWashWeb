Imports System

Partial Class jdAcercaDe
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Protección de Sesión obligatoria del Car Wash
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If
    End Sub

    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As EventArgs)
        ' Redirecciona de vuelta al panel o menú principal de la aplicación web
        Response.Redirect("FrmMenuPrincipal.aspx")
    End Sub
End Class