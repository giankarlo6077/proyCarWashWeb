Imports System.Web
Imports System.Web.UI

Public Module Seguridad

    Public Function EsAdministrador() As Boolean
        Return Convert.ToString(HttpContext.Current.Session("NombreRol")) = "Administrador"
    End Function

    Public Sub ExigirAdministrador(pagina As Page)
        If Not EsAdministrador() Then
            pagina.Response.Redirect("FrmMenuPrincipal.aspx")
        End If
    End Sub

End Module
