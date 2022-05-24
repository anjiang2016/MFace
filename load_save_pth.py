  1 #coding:utf-8
  2 import torch
  3
  4
  5 if __name__=="__main__":
  6     import pdb
  7     #pdb.set_trace()
  8     state=torch.load("Model_training_checkpoints/model_resnet18_triplet_epoch_586.pt")
  9     float_number = 0
 10     def savethispara(fp,weight):
 11         #weight=state['model_state_dict']['model.conv1.weight']
 12         length=weight.flatten().shape[0]
 13         weight_flatten = weight.flatten()
 14         fp.write("%f "%(length))
 15         for i in range(length):
 16             fp.write("%f "%(weight_flatten[i]))
 17         fp.flush()
 18         return length
 19
 20     fp =open("/Users/zhaomingming/Library/Mobile Documents/com~apple~CloudDocs/Documents/文稿1/CVPRO/MFace/MFace/model_resnet18_triplet_epoch_586.txt",    'wb')
 21     # save layer's and dict
 22     para_dict = state['model_state_dict'].keys()
 23     for i in range(len(para_dict)):
 24         print(para_dict[i])
 25         fp.write('%s '%(para_dict[i]))
 26         float_number +=1
 27         float_number +=savethispara(fp,state['model_state_dict']['%s'%(para_dict[i])])
 28
 29
 30     fp.close()
 31     print(float_number)
