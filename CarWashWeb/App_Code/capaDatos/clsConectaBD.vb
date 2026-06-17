Imports System.Data
Imports System.Data.SqlClient

Namespace capaDatos

    Public Class clsConectaBD
        Private cn As SqlConnection

        Sub New()
            cn = New SqlConnection()
            cn.ConnectionString = "workstation id=BDDistribuidos_4.mssql.somee.com;packet size=4096;user id=giankarlo6077_SQLLogin_4;pwd=bprg6leldj;data source=BDDistribuidos_4.mssql.somee.com;persist security info=False;initial catalog=BDDistribuidos_4;TrustServerCertificate=True;language=spanish"
        End Sub

        Public Sub conectar()
            Try
                If cn.State = Data.ConnectionState.Closed Then
                    cn.Open()
                End If
            Catch ex As Exception
                Throw New Exception("Error al conectar a BD")
            End Try
        End Sub

        Public Sub desconectar()
            Try
                If cn.State <> Data.ConnectionState.Closed Then
                    cn.Close()
                End If
            Catch ex As Exception
                Throw New Exception("Error al desconectar a BD")
            End Try
        End Sub

        Public ReadOnly Property estadoCN() As String
            Get
                If cn.State = Data.ConnectionState.Open Then
                    Return "BD está abierta."
                Else
                    Return "BD está cerrada."
                End If
            End Get
        End Property

        Public ReadOnly Property miConexion() As SqlConnection
            Get
                Return cn
            End Get
        End Property

        Public ReadOnly Property Servidor() As String
            Get
                Return cn.DataSource.ToString
            End Get
        End Property

        Public Sub abrirconexion()
            Try
                If cn.State <> Data.ConnectionState.Open Then
                    cn.Open()
                End If
            Catch Ex As Exception
                Err.Raise(Err.Number, Err.Source, Err.Description)
            End Try
        End Sub

        Public Sub cerrarconexion()
            Try
                If cn.State = Data.ConnectionState.Open Then
                    cn.Close()
                End If
            Catch Ex As Exception
                Err.Raise(Err.Number, Err.Source, Err.Description)
            End Try
        End Sub

    End Class

End Namespace
