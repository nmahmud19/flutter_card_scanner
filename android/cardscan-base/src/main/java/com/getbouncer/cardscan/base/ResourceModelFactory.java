package com.getbouncer.cardscan.base;

import android.content.Context;

import java.io.IOException;
import java.nio.MappedByteBuffer;

class ResourceModelFactory extends ModelFactory {
    @Override
    public MappedByteBuffer loadFindFourFile(Context context) throws IOException {
        return loadModelFromResource(context, R.raw.findfour);
//        return null;
    }

    @Override
    public MappedByteBuffer loadRecognizeDigitsFile(Context context) throws IOException {
        return loadModelFromResource(context, R.raw.fourrecognize);
//        return null;
    }
}
