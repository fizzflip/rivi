package me.prasad.study_app.data;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import me.prasad.study_app.data.dao.RiviDao;
import me.prasad.study_app.data.entity.Flashcard;
import me.prasad.study_app.data.entity.Subject;

/**
 * The Room database for the Rivi app.
 * Provides the main access point to the persisted data.
 */
@Database(entities = {Subject.class, Flashcard.class}, version = 1, exportSchema = false)
public abstract class RiviDatabase extends RoomDatabase {

    private static final int NUMBER_OF_THREADS = 4;
    /**
     * Executor service used to run database operations on a background thread.
     */
    public static final ExecutorService databaseWriteExecutor =
            Executors.newFixedThreadPool(NUMBER_OF_THREADS);
    private static volatile RiviDatabase INSTANCE;

    /**
     * Gets the singleton instance of the RiviDatabase.
     *
     * @param context The application context.
     * @return The RiviDatabase instance.
     */
    public static RiviDatabase getDatabase(final Context context) {
        if (INSTANCE == null) {
            synchronized (RiviDatabase.class) {
                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context.getApplicationContext(),
                                    RiviDatabase.class, "rivi_database")
                            .fallbackToDestructiveMigration() // Note: For MVP. In production, use migrations.
                            .build();
                }
            }
        }
        return INSTANCE;
    }

    public abstract RiviDao riviDao();
}
