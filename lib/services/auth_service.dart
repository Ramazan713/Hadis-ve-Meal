import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hadith/services/connectivity_service.dart';
import 'package:hadith/utils/loading_util.dart';
import 'package:hadith/utils/toast_utils.dart';

class AuthService{
   final _googleSignIn=GoogleSignIn();
   final _firebaseAuth=FirebaseAuth.instance;
   final _connectivityService=ConnectivityService();

   Future<void> signInWithGoogle(BuildContext context,{void Function()?successListener})async{

    try{
      final isOnline=await _connectivityService.isConnectInternet();
      if(!isOnline){
        ToastUtils.showLongToast("Internet bağlantınızı kontrol ediniz");
        return Future.value();
      }
      LoadingUtil.requestLoading(context);

      if(_googleSignIn.currentUser!=null){
        await _googleSignIn.currentUser?.clearAuthCache();
      }

      final googleSignInAccount=await _googleSignIn.signIn();
      if(googleSignInAccount!=null){

        final googleAuth=await googleSignInAccount.authentication;
        final credential=GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
        );
        final rs=await _firebaseAuth.signInWithCredential(credential);
        if(rs.user!=null){
          ToastUtils.showLongToast("Başarıyla Giriş Yapıldı");
          successListener?.call();
        }
      }else{
        ToastUtils.showLongToast("Bir şeyler yanlış gitti");
      }
    }
    on PlatformException catch(e){
      ToastUtils.showLongToast(e.code);
    }
    catch(e){
      ToastUtils.showLongToast("Bilinmeyen bir hata");
    }finally{
      LoadingUtil.requestCloseLoading(context);
    }
  }
   Future<void> signOut(BuildContext context)async{
      LoadingUtil.requestLoading(context);
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      ToastUtils.showLongToast("Başarıyla çıkış yapıldı");
      LoadingUtil.requestCloseLoading(context);
  }

   bool hasSignIn(){
    return _firebaseAuth.currentUser!=null;
  }

   Stream<User?>streamUser(){
    return _firebaseAuth.authStateChanges();
  }


}